import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';

enum CredentialFilter {
  all,
  user,
  admin,
  service,
  hash,
  valid,
  invalid,
  untested,
  clientProvided,
  passwordSpray,
  kerberoasting,
  localAdmin,
  domainAdmin,
}

class CredentialFilters {
  final Set<CredentialFilter> activeFilters;
  final String searchQuery;

  CredentialFilters({
    Set<CredentialFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {CredentialFilter.all};

  CredentialFilters copyWith({
    Set<CredentialFilter>? activeFilters,
    String? searchQuery,
  }) {
    return CredentialFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(CredentialFilter.all);
  bool get hasSearch => searchQuery.isNotEmpty;
}

class CredentialNotifier extends StateNotifier<List<Credential>> {
  CredentialNotifier() : super([]);

  void addCredential(Credential credential) {
    state = [...state, credential];
  }

  void updateCredential(Credential credential) {
    state = state.map((c) => c.id == credential.id ? credential : c).toList();
  }

  void deleteCredential(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void deleteCredentials(List<String> ids) {
    state = state.where((c) => !ids.contains(c.id)).toList();
  }

  void testCredential(String id, CredentialStatus status) {
    state = state.map((c) => c.id == id ? c.copyWith(
      status: status,
      lastTested: DateTime.now(),
    ) : c).toList();
  }

  void bulkTestCredentials(List<String> ids, CredentialStatus status) {
    final now = DateTime.now();
    state = state.map((c) => ids.contains(c.id) ? c.copyWith(
      status: status,
      lastTested: now,
    ) : c).toList();
  }
}

class CredentialFiltersNotifier extends StateNotifier<CredentialFilters> {
  CredentialFiltersNotifier() : super(CredentialFilters());

  void toggleFilter(CredentialFilter filter) {
    final currentFilters = Set<CredentialFilter>.from(state.activeFilters);
    
    if (filter == CredentialFilter.all) {
      state = CredentialFilters(activeFilters: {CredentialFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(CredentialFilter.all);
      }
    } else {
      currentFilters.remove(CredentialFilter.all);
      currentFilters.add(filter);
    }
    
    state = CredentialFilters(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = CredentialFilters();
  }
}

final credentialProvider = StateNotifierProvider<CredentialNotifier, List<Credential>>((ref) {
  return CredentialNotifier();
});

final credentialFiltersProvider = StateNotifierProvider<CredentialFiltersNotifier, CredentialFilters>((ref) {
  return CredentialFiltersNotifier();
});

final filteredCredentialsProvider = Provider<List<Credential>>((ref) {
  final credentials = ref.watch(credentialProvider);
  final filters = ref.watch(credentialFiltersProvider);

  var filtered = credentials.where((credential) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = credential.username.toLowerCase().contains(query) ||
          credential.target.toLowerCase().contains(query) ||
          credential.source.displayName.toLowerCase().contains(query) ||
          (credential.domain?.toLowerCase().contains(query) ?? false) ||
          (credential.notes?.toLowerCase().contains(query) ?? false);
      
      if (!matchesSearch) return false;
    }

    // Type and status filters
    if (filters.showAll) return true;

    bool matchesType = true;
    if (filters.activeFilters.contains(CredentialFilter.user)) {
      matchesType = credential.type == CredentialType.user;
    } else if (filters.activeFilters.contains(CredentialFilter.admin)) {
      matchesType = credential.type == CredentialType.admin;
    } else if (filters.activeFilters.contains(CredentialFilter.service)) {
      matchesType = credential.type == CredentialType.service;
    } else if (filters.activeFilters.contains(CredentialFilter.hash)) {
      matchesType = credential.type == CredentialType.hash;
    }

    bool matchesStatus = true;
    if (filters.activeFilters.contains(CredentialFilter.valid)) {
      matchesStatus = credential.status == CredentialStatus.valid;
    } else if (filters.activeFilters.contains(CredentialFilter.invalid)) {
      matchesStatus = credential.status == CredentialStatus.invalid;
    } else if (filters.activeFilters.contains(CredentialFilter.untested)) {
      matchesStatus = credential.status == CredentialStatus.untested;
    }

    bool matchesSource = true;
    if (filters.activeFilters.contains(CredentialFilter.clientProvided)) {
      matchesSource = credential.source == CredentialSource.clientProvided;
    } else if (filters.activeFilters.contains(CredentialFilter.passwordSpray)) {
      matchesSource = credential.source == CredentialSource.passwordSpray;
    } else if (filters.activeFilters.contains(CredentialFilter.kerberoasting)) {
      matchesSource = credential.source == CredentialSource.kerberoasting;
    }

    bool matchesPrivilege = true;
    if (filters.activeFilters.contains(CredentialFilter.localAdmin)) {
      matchesPrivilege = credential.privilege == CredentialPrivilege.localAdmin;
    } else if (filters.activeFilters.contains(CredentialFilter.domainAdmin)) {
      matchesPrivilege = credential.privilege == CredentialPrivilege.domainAdmin;
    }

    return matchesType && matchesStatus && matchesSource && matchesPrivilege;
  }).toList();

  // Sort by privilege (critical first), then by date added
  filtered.sort((a, b) {
    final privilegeOrder = {
      CredentialPrivilege.domainAdmin: 0,
      CredentialPrivilege.system: 1,
      CredentialPrivilege.localAdmin: 2,
      CredentialPrivilege.serviceAccount: 3,
      CredentialPrivilege.user: 4,
    };
    
    final privilegeComparison = privilegeOrder[a.privilege]!.compareTo(privilegeOrder[b.privilege]!);
    if (privilegeComparison != 0) return privilegeComparison;
    
    // Then by date added (most recent first)
    return b.dateAdded.compareTo(a.dateAdded);
  });
  
  return filtered;
});

final credentialSummaryProvider = Provider<Map<String, int>>((ref) {
  final credentials = ref.watch(credentialProvider);

  int totalCredentials = credentials.length;
  int validCredentials = credentials.where((c) => c.status == CredentialStatus.valid).length;
  int adminCredentials = credentials.where((c) => c.privilege.isCritical).length;
  int untestedCredentials = credentials.where((c) => c.status == CredentialStatus.untested).length;

  return {
    'totalCredentials': totalCredentials,
    'validCredentials': validCredentials,
    'adminCredentials': adminCredentials,
    'untestedCredentials': untestedCredentials,
  };
});