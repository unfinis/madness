import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document.dart';

enum DocumentFilter {
  all,
  authorisationForms,
  statementOfWork,
  presalesNotes,
  scopingDocuments,
  technicalDocuments,
  drafts,
  inReview,
  approved,
  finalized,
  archived,
  confidential,
}

class DocumentFilters {
  final Set<DocumentFilter> activeFilters;
  final String searchQuery;

  DocumentFilters({
    Set<DocumentFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {DocumentFilter.all};

  DocumentFilters copyWith({
    Set<DocumentFilter>? activeFilters,
    String? searchQuery,
  }) {
    return DocumentFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(DocumentFilter.all);
  bool get hasSearch => searchQuery.isNotEmpty;
}

class DocumentNotifier extends StateNotifier<List<Document>> {
  DocumentNotifier() : super([]);

  void addDocument(Document document) {
    state = [...state, document];
  }

  void updateDocument(Document document) {
    state = state.map((d) => d.id == document.id ? document : d).toList();
  }

  void deleteDocument(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  void duplicateDocument(String id) {
    final original = state.firstWhere((d) => d.id == id);
    final duplicate = original.copyWith(
      name: '${original.name} (Copy)',
      status: DocumentStatus.draft,
      version: null,
      dateApproved: null,
      approvedBy: null,
    );
    addDocument(duplicate);
  }

  void updateDocumentStatus(String id, DocumentStatus status) {
    final document = state.firstWhere((d) => d.id == id);
    final updatedDocument = document.copyWith(
      status: status,
      dateApproved: status == DocumentStatus.approved ? DateTime.now() : null,
      approvedBy: status == DocumentStatus.approved ? 'Current User' : null,
    );
    updateDocument(updatedDocument);
  }
}

class DocumentFiltersNotifier extends StateNotifier<DocumentFilters> {
  DocumentFiltersNotifier() : super(DocumentFilters());

  void toggleFilter(DocumentFilter filter) {
    final currentFilters = Set<DocumentFilter>.from(state.activeFilters);
    
    if (filter == DocumentFilter.all) {
      state = state.copyWith(activeFilters: {DocumentFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(DocumentFilter.all);
      }
    } else {
      currentFilters.remove(DocumentFilter.all);
      currentFilters.add(filter);
    }
    
    state = state.copyWith(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = DocumentFilters();
  }
}

final documentProvider = StateNotifierProvider<DocumentNotifier, List<Document>>((ref) {
  return DocumentNotifier();
});

final documentFiltersProvider = StateNotifierProvider<DocumentFiltersNotifier, DocumentFilters>((ref) {
  return DocumentFiltersNotifier();
});

final filteredDocumentsProvider = Provider<List<Document>>((ref) {
  final documents = ref.watch(documentProvider);
  final filters = ref.watch(documentFiltersProvider);

  var filtered = documents.where((document) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = document.name.toLowerCase().contains(query) ||
          document.description.toLowerCase().contains(query) ||
          document.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          (document.author?.toLowerCase().contains(query) ?? false);
      
      if (!matchesSearch) return false;
    }

    // Category filters
    if (filters.showAll) return true;

    bool matchesFilter = false;
    
    // Type filters
    if (filters.activeFilters.contains(DocumentFilter.authorisationForms)) {
      matchesFilter = matchesFilter || document.type == DocumentType.authorisationForms;
    }
    if (filters.activeFilters.contains(DocumentFilter.statementOfWork)) {
      matchesFilter = matchesFilter || document.type == DocumentType.statementOfWork;
    }
    if (filters.activeFilters.contains(DocumentFilter.presalesNotes)) {
      matchesFilter = matchesFilter || document.type == DocumentType.presalesNotes;
    }
    if (filters.activeFilters.contains(DocumentFilter.scopingDocuments)) {
      matchesFilter = matchesFilter || document.type == DocumentType.scopingDocuments;
    }
    if (filters.activeFilters.contains(DocumentFilter.technicalDocuments)) {
      matchesFilter = matchesFilter || document.type == DocumentType.technicalDocuments;
    }

    // Status filters
    if (filters.activeFilters.contains(DocumentFilter.drafts)) {
      matchesFilter = matchesFilter || document.status == DocumentStatus.draft;
    }
    if (filters.activeFilters.contains(DocumentFilter.inReview)) {
      matchesFilter = matchesFilter || document.status == DocumentStatus.inReview;
    }
    if (filters.activeFilters.contains(DocumentFilter.approved)) {
      matchesFilter = matchesFilter || document.status == DocumentStatus.approved;
    }
    if (filters.activeFilters.contains(DocumentFilter.finalized)) {
      matchesFilter = matchesFilter || document.status == DocumentStatus.finalized;
    }
    if (filters.activeFilters.contains(DocumentFilter.archived)) {
      matchesFilter = matchesFilter || document.status == DocumentStatus.archived;
    }

    // Special filters
    if (filters.activeFilters.contains(DocumentFilter.confidential)) {
      matchesFilter = matchesFilter || document.isConfidential;
    }

    return matchesFilter;
  }).toList();

  // Sort by date modified (most recent first)
  filtered.sort((a, b) => b.dateModified.compareTo(a.dateModified));
  
  return filtered;
});

final documentSummaryProvider = Provider<Map<String, int>>((ref) {
  final documents = ref.watch(documentProvider);

  return {
    'total': documents.length,
    'drafts': documents.where((d) => d.status == DocumentStatus.draft).length,
    'inReview': documents.where((d) => d.status == DocumentStatus.inReview).length,
    'approved': documents.where((d) => d.status == DocumentStatus.approved).length,
    'final': documents.where((d) => d.status == DocumentStatus.finalized).length,
    'authorisationForms': documents.where((d) => d.type == DocumentType.authorisationForms).length,
    'statementOfWork': documents.where((d) => d.type == DocumentType.statementOfWork).length,
    'presalesNotes': documents.where((d) => d.type == DocumentType.presalesNotes).length,
    'scopingDocuments': documents.where((d) => d.type == DocumentType.scopingDocuments).length,
    'technicalDocuments': documents.where((d) => d.type == DocumentType.technicalDocuments).length,
    'confidential': documents.where((d) => d.isConfidential).length,
  };
});