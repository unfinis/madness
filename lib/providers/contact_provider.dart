import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../database/database.dart';
import 'database_provider.dart';

enum ContactFilter {
  all,
  primary,
  technical,
  emergency,
  escalation,
  securityConsultant,
  accountManager,
  receiveReport,
}

class ContactFilters {
  final Set<ContactFilter> activeFilters;
  final String searchQuery;

  ContactFilters({
    Set<ContactFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {ContactFilter.all};

  ContactFilters copyWith({
    Set<ContactFilter>? activeFilters,
    String? searchQuery,
  }) {
    return ContactFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(ContactFilter.all);
  bool get hasSearch => searchQuery.isNotEmpty;
}

class ContactNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  final MadnessDatabase _database;
  final String _projectId;

  ContactNotifier(this._database, this._projectId) : super(const AsyncValue.loading()) {
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await _database.getAllContacts(_projectId);
      state = AsyncValue.data(contacts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await _database.insertContact(contact, _projectId);
      await _loadContacts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _database.updateContact(contact, _projectId);
      await _loadContacts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await _database.deleteContact(id);
      await _loadContacts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() {
    _loadContacts();
  }
}

class ContactFiltersNotifier extends StateNotifier<ContactFilters> {
  ContactFiltersNotifier() : super(ContactFilters());

  void toggleFilter(ContactFilter filter) {
    final currentFilters = Set<ContactFilter>.from(state.activeFilters);
    
    if (filter == ContactFilter.all) {
      state = ContactFilters(activeFilters: {ContactFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(ContactFilter.all);
      }
    } else {
      currentFilters.remove(ContactFilter.all);
      currentFilters.add(filter);
    }
    
    state = ContactFilters(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = ContactFilters();
  }
}

final contactProvider = StateNotifierProvider.family<ContactNotifier, AsyncValue<List<Contact>>, String>((ref, projectId) {
  final database = ref.watch(databaseProvider);
  return ContactNotifier(database, projectId);
});

final contactFiltersProvider = StateNotifierProvider<ContactFiltersNotifier, ContactFilters>((ref) {
  return ContactFiltersNotifier();
});

final filteredContactsProvider = Provider.family<AsyncValue<List<Contact>>, String>((ref, projectId) {
  final contactsAsync = ref.watch(contactProvider(projectId));
  final filters = ref.watch(contactFiltersProvider);

  return contactsAsync.when(
    data: (contacts) {

  var filtered = contacts.where((contact) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = contact.name.toLowerCase().contains(query) ||
          contact.email.toLowerCase().contains(query) ||
          contact.phone.toLowerCase().contains(query) ||
          contact.role.toLowerCase().contains(query) ||
          contact.tags.any((tag) => tag.toLowerCase().contains(query));
      
      if (!matchesSearch) return false;
    }

    // Category filters
    if (filters.showAll) return true;

    bool matchesFilter = false;
    
    if (filters.activeFilters.contains(ContactFilter.primary)) {
      matchesFilter = matchesFilter || contact.tags.contains('Primary');
    }
    if (filters.activeFilters.contains(ContactFilter.technical)) {
      matchesFilter = matchesFilter || contact.tags.contains('Technical');
    }
    if (filters.activeFilters.contains(ContactFilter.emergency)) {
      matchesFilter = matchesFilter || contact.tags.contains('Emergency');
    }
    if (filters.activeFilters.contains(ContactFilter.escalation)) {
      matchesFilter = matchesFilter || contact.tags.contains('Escalation');
    }
    if (filters.activeFilters.contains(ContactFilter.securityConsultant)) {
      matchesFilter = matchesFilter || contact.tags.contains('Security Consultant');
    }
    if (filters.activeFilters.contains(ContactFilter.accountManager)) {
      matchesFilter = matchesFilter || contact.tags.contains('Account Manager');
    }
    if (filters.activeFilters.contains(ContactFilter.receiveReport)) {
      matchesFilter = matchesFilter || contact.tags.contains('Receive Report');
    }

    return matchesFilter;
  }).toList();

      // Sort by name
      filtered.sort((a, b) => a.name.compareTo(b.name));
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final contactSummaryProvider = Provider.family<Map<String, int>, String>((ref, projectId) {
  final contactsAsync = ref.watch(contactProvider(projectId));

  return contactsAsync.when(
    data: (contacts) {
      int totalContacts = contacts.length;
      int emergencyContacts = contacts.where((c) => c.tags.contains('Emergency')).length;
      int technicalContacts = contacts.where((c) => c.tags.contains('Technical')).length;
      int reportRecipients = contacts.where((c) => c.tags.contains('Receive Report')).length;

      return {
        'total': totalContacts,
        'emergency': emergencyContacts,
        'technical': technicalContacts,
        'reportRecipients': reportRecipients,
      };
    },
    loading: () => {
      'total': 0,
      'emergency': 0,
      'technical': 0,
      'reportRecipients': 0,
    },
    error: (error, stackTrace) => {
      'total': 0,
      'emergency': 0,
      'technical': 0,
      'reportRecipients': 0,
    },
  );
});