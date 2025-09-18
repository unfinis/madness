import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';

enum ScopeFilter {
  all,
  active,
  planned,
  external,
  internal,
  webapp,
  wireless,
  mobile,
  api,
  cloud,
  activeDirectory,
  iot,
  completed,
  onHold,
}

class ScopeFilters {
  final Set<ScopeFilter> activeFilters;
  final String searchQuery;

  ScopeFilters({
    Set<ScopeFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {ScopeFilter.all};

  ScopeFilters copyWith({
    Set<ScopeFilter>? activeFilters,
    String? searchQuery,
  }) {
    return ScopeFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(ScopeFilter.all);
  bool get hasSearch => searchQuery.isNotEmpty;
}

class ScopeNotifier extends StateNotifier<List<ScopeSegment>> {
  ScopeNotifier() : super(_mockScopeSegments());

  void addSegment(ScopeSegment segment) {
    state = [...state, segment];
  }

  void updateSegment(ScopeSegment segment) {
    state = state.map((s) => s.id == segment.id ? segment : s).toList();
  }

  void deleteSegment(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void addItemToSegment(String segmentId, ScopeItem item) {
    state = state.map((segment) {
      if (segment.id == segmentId) {
        return segment.copyWith(items: [...segment.items, item]);
      }
      return segment;
    }).toList();
  }

  void updateItemInSegment(String segmentId, ScopeItem item) {
    state = state.map((segment) {
      if (segment.id == segmentId) {
        final updatedItems = segment.items.map((i) => i.id == item.id ? item : i).toList();
        return segment.copyWith(items: updatedItems);
      }
      return segment;
    }).toList();
  }

  void deleteItemFromSegment(String segmentId, String itemId) {
    state = state.map((segment) {
      if (segment.id == segmentId) {
        final updatedItems = segment.items.where((i) => i.id != itemId).toList();
        return segment.copyWith(items: updatedItems);
      }
      return segment;
    }).toList();
  }

  static List<ScopeSegment> _mockScopeSegments() {
    return [];
  }
}

class ScopeFiltersNotifier extends StateNotifier<ScopeFilters> {
  ScopeFiltersNotifier() : super(ScopeFilters());

  void toggleFilter(ScopeFilter filter) {
    final currentFilters = Set<ScopeFilter>.from(state.activeFilters);
    
    if (filter == ScopeFilter.all) {
      state = ScopeFilters(activeFilters: {ScopeFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(ScopeFilter.all);
      }
    } else {
      currentFilters.remove(ScopeFilter.all);
      currentFilters.add(filter);
    }
    
    state = ScopeFilters(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = ScopeFilters();
  }
}

final scopeProvider = StateNotifierProvider<ScopeNotifier, List<ScopeSegment>>((ref) {
  return ScopeNotifier();
});

final scopeFiltersProvider = StateNotifierProvider<ScopeFiltersNotifier, ScopeFilters>((ref) {
  return ScopeFiltersNotifier();
});

final filteredScopeSegmentsProvider = Provider<List<ScopeSegment>>((ref) {
  final segments = ref.watch(scopeProvider);
  final filters = ref.watch(scopeFiltersProvider);

  var filtered = segments.where((segment) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = segment.title.toLowerCase().contains(query) ||
          (segment.description?.toLowerCase().contains(query) ?? false) ||
          segment.items.any((item) => 
            item.target.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query)
          );
      
      if (!matchesSearch) return false;
    }

    // Type and status filters
    if (filters.showAll) return true;

    bool matchesType = true;
    if (filters.activeFilters.contains(ScopeFilter.external)) {
      matchesType = segment.type == ScopeSegmentType.external;
    } else if (filters.activeFilters.contains(ScopeFilter.internal)) {
      matchesType = segment.type == ScopeSegmentType.internal;
    } else if (filters.activeFilters.contains(ScopeFilter.webapp)) {
      matchesType = segment.type == ScopeSegmentType.webapp;
    } else if (filters.activeFilters.contains(ScopeFilter.wireless)) {
      matchesType = segment.type == ScopeSegmentType.wireless;
    } else if (filters.activeFilters.contains(ScopeFilter.mobile)) {
      matchesType = segment.type == ScopeSegmentType.mobile;
    } else if (filters.activeFilters.contains(ScopeFilter.api)) {
      matchesType = segment.type == ScopeSegmentType.api;
    } else if (filters.activeFilters.contains(ScopeFilter.cloud)) {
      matchesType = segment.type == ScopeSegmentType.cloud;
    } else if (filters.activeFilters.contains(ScopeFilter.activeDirectory)) {
      matchesType = segment.type == ScopeSegmentType.activeDirectory;
    } else if (filters.activeFilters.contains(ScopeFilter.iot)) {
      matchesType = segment.type == ScopeSegmentType.iot;
    }

    bool matchesStatus = true;
    if (filters.activeFilters.contains(ScopeFilter.active)) {
      matchesStatus = segment.status == ScopeSegmentStatus.active;
    } else if (filters.activeFilters.contains(ScopeFilter.planned)) {
      matchesStatus = segment.status == ScopeSegmentStatus.planned;
    } else if (filters.activeFilters.contains(ScopeFilter.completed)) {
      matchesStatus = segment.status == ScopeSegmentStatus.completed;
    } else if (filters.activeFilters.contains(ScopeFilter.onHold)) {
      matchesStatus = segment.status == ScopeSegmentStatus.onHold;
    }

    return matchesType && matchesStatus;
  }).toList();

  // Sort by status priority, then by start date
  filtered.sort((a, b) {
    final statusOrder = {
      ScopeSegmentStatus.active: 0,
      ScopeSegmentStatus.planned: 1,
      ScopeSegmentStatus.onHold: 2,
      ScopeSegmentStatus.completed: 3,
    };
    
    final statusComparison = statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
    if (statusComparison != 0) return statusComparison;
    
    // Then by start date (most recent first)
    if (a.startDate == null && b.startDate == null) return 0;
    if (a.startDate == null) return 1;
    if (b.startDate == null) return -1;
    return b.startDate!.compareTo(a.startDate!);
  });
  
  return filtered;
});

final scopeSummaryProvider = Provider<Map<String, int>>((ref) {
  final segments = ref.watch(scopeProvider);

  int totalSegments = segments.length;
  int activeSegments = segments.where((s) => s.status == ScopeSegmentStatus.active).length;
  int plannedSegments = segments.where((s) => s.status == ScopeSegmentStatus.planned).length;
  int completedSegments = segments.where((s) => s.status == ScopeSegmentStatus.completed).length;
  int totalItems = segments.fold(0, (sum, segment) => sum + segment.totalItemsCount);
  int activeItems = segments.fold(0, (sum, segment) => sum + segment.activeItemsCount);

  return {
    'totalSegments': totalSegments,
    'activeSegments': activeSegments,
    'plannedSegments': plannedSegments,
    'completedSegments': completedSegments,
    'totalItems': totalItems,
    'activeItems': activeItems,
  };
});