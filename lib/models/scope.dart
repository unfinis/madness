enum ScopeSegmentType {
  external,
  internal,
  webapp,
  wireless,
  mobile,
  api,
  cloud,
  activeDirectory,
  iot,
}

enum ScopeItemType {
  url,
  domain,
  ipRange,
  host,
  network,
}

enum ScopeSegmentStatus {
  planned,
  active,
  completed,
  onHold,
}

class ScopeItem {
  final String id;
  final ScopeItemType type;
  final String target;
  final String description;
  final DateTime dateAdded;
  final bool isActive;
  final String? notes;

  ScopeItem({
    required this.id,
    required this.type,
    required this.target,
    required this.description,
    required this.dateAdded,
    this.isActive = true,
    this.notes,
  });

  ScopeItem copyWith({
    String? id,
    ScopeItemType? type,
    String? target,
    String? description,
    DateTime? dateAdded,
    bool? isActive,
    String? notes,
  }) {
    return ScopeItem(
      id: id ?? this.id,
      type: type ?? this.type,
      target: target ?? this.target,
      description: description ?? this.description,
      dateAdded: dateAdded ?? this.dateAdded,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }
}

class ScopeSegment {
  final String id;
  final String title;
  final ScopeSegmentType type;
  final ScopeSegmentStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ScopeItem> items;
  final String? description;
  final String? notes;

  ScopeSegment({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.startDate,
    this.endDate,
    this.items = const [],
    this.description,
    this.notes,
  });

  int get activeItemsCount => items.where((item) => item.isActive).length;
  int get totalItemsCount => items.length;

  ScopeSegment copyWith({
    String? id,
    String? title,
    ScopeSegmentType? type,
    ScopeSegmentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<ScopeItem>? items,
    String? description,
    String? notes,
  }) {
    return ScopeSegment(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      items: items ?? this.items,
      description: description ?? this.description,
      notes: notes ?? this.notes,
    );
  }
}

extension ScopeSegmentTypeExtension on ScopeSegmentType {
  String get displayName {
    switch (this) {
      case ScopeSegmentType.external:
        return 'External';
      case ScopeSegmentType.internal:
        return 'Internal';
      case ScopeSegmentType.webapp:
        return 'Web App';
      case ScopeSegmentType.wireless:
        return 'Wireless';
      case ScopeSegmentType.mobile:
        return 'Mobile App';
      case ScopeSegmentType.api:
        return 'API Testing';
      case ScopeSegmentType.cloud:
        return 'Cloud';
      case ScopeSegmentType.activeDirectory:
        return 'Active Directory';
      case ScopeSegmentType.iot:
        return 'IoT Devices';
    }
  }

  String get icon {
    switch (this) {
      case ScopeSegmentType.external:
        return '🌍';
      case ScopeSegmentType.internal:
        return '🏢';
      case ScopeSegmentType.webapp:
        return '🌐';
      case ScopeSegmentType.wireless:
        return '📶';
      case ScopeSegmentType.mobile:
        return '📱';
      case ScopeSegmentType.api:
        return '🔌';
      case ScopeSegmentType.cloud:
        return '☁️';
      case ScopeSegmentType.activeDirectory:
        return '🔐';
      case ScopeSegmentType.iot:
        return '🌐';
    }
  }
}

extension ScopeItemTypeExtension on ScopeItemType {
  String get displayName {
    switch (this) {
      case ScopeItemType.url:
        return 'URL';
      case ScopeItemType.domain:
        return 'Domain';
      case ScopeItemType.ipRange:
        return 'IP Range';
      case ScopeItemType.host:
        return 'Host';
      case ScopeItemType.network:
        return 'Network';
    }
  }

  String get icon {
    switch (this) {
      case ScopeItemType.url:
        return '🔗';
      case ScopeItemType.domain:
        return '🌐';
      case ScopeItemType.ipRange:
        return '📡';
      case ScopeItemType.host:
        return '💻';
      case ScopeItemType.network:
        return '🌐';
    }
  }
}

extension ScopeSegmentStatusExtension on ScopeSegmentStatus {
  String get displayName {
    switch (this) {
      case ScopeSegmentStatus.planned:
        return 'Planned';
      case ScopeSegmentStatus.active:
        return 'Active';
      case ScopeSegmentStatus.completed:
        return 'Completed';
      case ScopeSegmentStatus.onHold:
        return 'On Hold';
    }
  }

  String get icon {
    switch (this) {
      case ScopeSegmentStatus.planned:
        return '📋';
      case ScopeSegmentStatus.active:
        return '🔄';
      case ScopeSegmentStatus.completed:
        return '✅';
      case ScopeSegmentStatus.onHold:
        return '⏸️';
    }
  }
}