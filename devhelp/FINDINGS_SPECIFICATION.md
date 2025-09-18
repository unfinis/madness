# Findings Implementation Specification

## Overview
This specification outlines the implementation of a findings management system for Madness, combining the existing finding editor functionality with the wireframe design system. The findings system will enable security professionals to create, manage, and track security vulnerabilities throughout penetration testing engagements.

## Table of Contents
1. [Design System Integration](#design-system-integration)
2. [Database Schema](#database-schema)
3. [Flutter Model Structure](#flutter-model-structure)
4. [UI Components](#ui-components)
5. [Screen Layouts](#screen-layouts)
6. [Provider Architecture](#provider-architecture)
7. [Feature Requirements](#feature-requirements)
8. [Integration Points](#integration-points)
9. [Implementation Phases](#implementation-phases)

## Design System Integration

### Color Variables (From Wireframe)
```css
/* Primary Colors */
--bg-body: var(--grey-50);
--bg-primary: #ffffff;
--bg-secondary: var(--grey-100);
--bg-accent: #eff6ff;
--text-primary: var(--grey-900);
--text-secondary: var(--grey-500);
--text-accent: #3b82f6;
--border-color: var(--grey-200);

/* Severity Colors */
--critical: #ef4444;
--high: #f59e0b;
--medium: #10b981;
--low: #3b82f6;
--info: #6b7280;

/* Button Colors */
--button-primary: #3b82f6;
--button-hover: #2563eb;
--success: #10b981;
--warning: #f59e0b;
--danger: #ef4444;
```

### Typography
```css
--font-xs: 0.75rem;
--font-sm: 0.875rem;
--font-base: 1rem;
--font-lg: 1.125rem;
--font-xl: 1.25rem;
--font-2xl: 1.5rem;
```

### Spacing & Border Radius
```css
--spacing-xs: 0.25rem;
--spacing-sm: 0.5rem;
--spacing-md: 1rem;
--spacing-lg: 1.5rem;
--spacing-xl: 2rem;

--radius-small: 4px;
--radius-medium: 8px;
--radius-large: 12px;
```

## Database Schema

### Core Findings Table
```dart
@DataClassName('FindingRow')
class FindingsTable extends Table {
  @override
  String get tableName => 'findings';
  
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get cvssScore => real().named('cvss_score')();
  TextColumn get cvssVector => text().named('cvss_vector').nullable()();
  TextColumn get severity => text()(); // critical, high, medium, low, info
  TextColumn get status => text().withDefault(const Constant('draft'))(); // draft, active, resolved, false_positive
  TextColumn get auditSteps => text().named('audit_steps').nullable()();
  TextColumn get automatedScript => text().named('automated_script').nullable()();
  TextColumn get furtherReading => text().named('further_reading').nullable()();
  TextColumn get verificationProcedure => text().named('verification_procedure').nullable()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get updatedDate => dateTime().named('updated_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Finding Components Table
```dart
@DataClassName('FindingComponentRow')
class FindingComponentsTable extends Table {
  @override
  String get tableName => 'finding_components';
  
  TextColumn get id => text()();
  TextColumn get findingId => text().named('finding_id').references(FindingsTable, #id)();
  TextColumn get componentType => text().named('component_type')(); // hostname, ip, url, etc.
  TextColumn get name => text()();
  TextColumn get value => text()();
  TextColumn get description => text().nullable()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Finding Links Table  
```dart
@DataClassName('FindingLinkRow')
class FindingLinksTable extends Table {
  @override
  String get tableName => 'finding_links';
  
  TextColumn get id => text()();
  TextColumn get findingId => text().named('finding_id').references(FindingsTable, #id)();
  TextColumn get title => text()();
  TextColumn get url => text()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Finding Templates Table
```dart
@DataClassName('FindingTemplateRow')
class FindingTemplatesTable extends Table {
  @override
  String get tableName => 'finding_templates';
  
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get baseDescription => text().named('base_description')();
  TextColumn get automatedScript => text().named('automated_script').nullable()();
  BoolColumn get isBuiltIn => boolean().named('is_built_in').withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get updatedDate => dateTime().named('updated_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Sub-Findings Table
```dart
@DataClassName('SubFindingRow')
class SubFindingsTable extends Table {
  @override
  String get tableName => 'sub_findings';
  
  TextColumn get id => text()();
  TextColumn get templateId => text().named('template_id').references(FindingTemplatesTable, #id)();
  TextColumn get subFindingId => text().named('sub_finding_id')(); // unique within template
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get cvssScore => real().named('cvss_score')();
  TextColumn get cvssVector => text().named('cvss_vector')();
  TextColumn get severity => text()();
  TextColumn get checkSteps => text().named('check_steps')();
  TextColumn get recommendation => text()();
  TextColumn get verificationProcedure => text().named('verification_procedure').nullable()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Sub-Finding Links Table
```dart
@DataClassName('SubFindingLinkRow')
class SubFindingLinksTable extends Table {
  @override
  String get tableName => 'sub_finding_links';
  
  TextColumn get id => text()();
  TextColumn get subFindingId => text().named('sub_finding_id').references(SubFindingsTable, #id)();
  TextColumn get title => text()();
  TextColumn get url => text()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Screenshot Placeholders Table
```dart
@DataClassName('ScreenshotPlaceholderRow')
class ScreenshotPlaceholdersTable extends Table {
  @override
  String get tableName => 'screenshot_placeholders';
  
  TextColumn get id => text()();
  TextColumn get subFindingId => text().named('sub_finding_id').references(SubFindingsTable, #id)();
  TextColumn get caption => text()();
  TextColumn get steps => text()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Update Existing Screenshot-Finding Relationship
```dart
// Already exists in current schema:
// ScreenshotFindingsTable - links screenshots to findings
// Extended to support subfinding associations:
class ScreenshotFindingsTable extends Table {
  // ... existing columns
  TextColumn get subFindingId => text().named('sub_finding_id').nullable()();
  TextColumn get subFindingTitle => text().named('sub_finding_title').nullable()();
}
```

## Flutter Model Structure

### Core Finding Model
```dart
class Finding {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final double cvssScore;
  final String? cvssVector;
  final FindingSeverity severity;
  final FindingStatus status;
  final String? auditSteps;
  final String? automatedScript;
  final String? furtherReading;
  final String? verificationProcedure;
  final int orderIndex;
  final DateTime createdDate;
  final DateTime updatedDate;
  
  // Related data
  final List<FindingComponent> components;
  final List<FindingLink> links;
  final List<Screenshot> screenshots;
  
  Finding({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.cvssScore,
    this.cvssVector,
    required this.severity,
    required this.status,
    this.auditSteps,
    this.automatedScript,
    this.furtherReading,
    this.verificationProcedure,
    this.orderIndex = 0,
    required this.createdDate,
    required this.updatedDate,
    this.components = const [],
    this.links = const [],
    this.screenshots = const [],
  });
  
  // Computed properties
  String get severityDisplay => severity.displayName;
  Color get severityColor => severity.color;
  String get statusDisplay => status.displayName;
  bool get isComplete => status == FindingStatus.resolved;
}

enum FindingSeverity {
  critical,
  high,
  medium,
  low,
  info;
  
  String get displayName {
    switch (this) {
      case FindingSeverity.critical:
        return 'Critical';
      case FindingSeverity.high:
        return 'High';
      case FindingSeverity.medium:
        return 'Medium';
      case FindingSeverity.low:
        return 'Low';
      case FindingSeverity.info:
        return 'Info';
    }
  }
  
  Color get color {
    switch (this) {
      case FindingSeverity.critical:
        return const Color(0xFFef4444); // --danger
      case FindingSeverity.high:
        return const Color(0xFFf59e0b); // --warning
      case FindingSeverity.medium:
        return const Color(0xFFfbbf24);
      case FindingSeverity.low:
        return const Color(0xFF10b981); // --success
      case FindingSeverity.info:
        return const Color(0xFF6b7280);
    }
  }
  
  static FindingSeverity fromScore(double score) {
    if (score >= 9.0) return FindingSeverity.critical;
    if (score >= 7.0) return FindingSeverity.high;
    if (score >= 4.0) return FindingSeverity.medium;
    if (score >= 0.1) return FindingSeverity.low;
    return FindingSeverity.info;
  }
}

enum FindingStatus {
  draft,
  active,
  resolved,
  falsePositive;
  
  String get displayName {
    switch (this) {
      case FindingStatus.draft:
        return 'Draft';
      case FindingStatus.active:
        return 'Active';
      case FindingStatus.resolved:
        return 'Resolved';
      case FindingStatus.falsePositive:
        return 'False Positive';
    }
  }
}
```

### Template Models
```dart
class FindingTemplate {
  final String id;
  final String title;
  final String category;
  final String baseDescription;
  final String? automatedScript;
  final bool isBuiltIn;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;
  final List<SubFinding> subFindings;
  
  FindingTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.baseDescription,
    this.automatedScript,
    this.isBuiltIn = false,
    this.isActive = true,
    required this.createdDate,
    required this.updatedDate,
    this.subFindings = const [],
  });
  
  // JSON serialization methods for export/import
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'baseDescription': baseDescription,
    'automatedScript': automatedScript,
    'subFindings': subFindings.map((sf) => sf.toJson()).toList(),
  };
  
  factory FindingTemplate.fromJson(Map<String, dynamic> json) => FindingTemplate(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    baseDescription: json['baseDescription'] ?? '',
    automatedScript: json['automatedScript'],
    createdDate: DateTime.now(),
    updatedDate: DateTime.now(),
    subFindings: (json['subFindings'] as List<dynamic>?)
        ?.map((sf) => SubFinding.fromJson(sf))
        .toList() ?? [],
  );
}

class SubFinding {
  final String id;
  final String templateId;
  final String subFindingId; // unique within template
  final String title;
  final String description;
  final double cvssScore;
  final String cvssVector;
  final FindingSeverity severity;
  final String checkSteps;
  final String recommendation;
  final String? verificationProcedure;
  final int orderIndex;
  final DateTime createdDate;
  final List<FindingLink> links;
  final List<ScreenshotPlaceholder> screenshotPlaceholders;
  
  SubFinding({
    required this.id,
    required this.templateId,
    required this.subFindingId,
    required this.title,
    required this.description,
    required this.cvssScore,
    required this.cvssVector,
    required this.severity,
    required this.checkSteps,
    required this.recommendation,
    this.verificationProcedure,
    this.orderIndex = 0,
    required this.createdDate,
    this.links = const [],
    this.screenshotPlaceholders = const [],
  });
  
  Map<String, dynamic> toJson() => {
    'id': subFindingId,
    'title': title,
    'description': description,
    'cvssScore': cvssScore,
    'cvssVector': cvssVector,
    'severity': severity.name,
    'checkSteps': checkSteps,
    'recommendation': recommendation,
    'verificationProcedure': verificationProcedure,
    'links': links.map((l) => l.toJson()).toList(),
    'screenshotPlaceholders': screenshotPlaceholders.map((sp) => sp.toJson()).toList(),
  };
  
  factory SubFinding.fromJson(Map<String, dynamic> json) => SubFinding(
    id: '',
    templateId: '',
    subFindingId: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    cvssScore: (json['cvssScore'] ?? 0.0).toDouble(),
    cvssVector: json['cvssVector'] ?? '',
    severity: FindingSeverity.fromScore((json['cvssScore'] ?? 0.0).toDouble()),
    checkSteps: json['checkSteps'] ?? '',
    recommendation: json['recommendation'] ?? '',
    verificationProcedure: json['verificationProcedure'],
    createdDate: DateTime.now(),
    links: (json['links'] as List<dynamic>?)
        ?.map((l) => FindingLink.fromJson(l))
        .toList() ?? [],
    screenshotPlaceholders: (json['screenshotPlaceholders'] as List<dynamic>?)
        ?.map((sp) => ScreenshotPlaceholder.fromJson(sp))
        .toList() ?? [],
  );
}

class ScreenshotPlaceholder {
  final String id;
  final String subFindingId;
  final String caption;
  final String steps;
  final int orderIndex;
  final DateTime createdDate;
  
  ScreenshotPlaceholder({
    required this.id,
    required this.subFindingId,
    required this.caption,
    required this.steps,
    this.orderIndex = 0,
    required this.createdDate,
  });
  
  Map<String, dynamic> toJson() => {
    'caption': caption,
    'steps': steps,
  };
  
  factory ScreenshotPlaceholder.fromJson(Map<String, dynamic> json) => 
    ScreenshotPlaceholder(
      id: '',
      subFindingId: '',
      caption: json['caption'] ?? '',
      steps: json['steps'] ?? '',
      createdDate: DateTime.now(),
    );
}

// Template Selection State
class TemplateSelection {
  final FindingTemplate template;
  final Set<int> selectedSubFindings;
  final double highestScore;
  final double averageScore;
  
  TemplateSelection({
    required this.template,
    required this.selectedSubFindings,
    required this.highestScore,
    required this.averageScore,
  });
  
  List<SubFinding> get selectedSubFindingsList =>
      selectedSubFindings.map((index) => template.subFindings[index]).toList();
  
  bool get hasSelection => selectedSubFindings.isNotEmpty;
  
  int get selectedCount => selectedSubFindings.length;
}
```

### Component and Link Models
```dart
class FindingComponent {
  final String id;
  final String findingId;
  final ComponentType type;
  final String name;
  final String value;
  final String? description;
  final int orderIndex;
  final DateTime createdDate;
  
  FindingComponent({
    required this.id,
    required this.findingId,
    required this.type,
    required this.name,
    required this.value,
    this.description,
    this.orderIndex = 0,
    required this.createdDate,
  });
}

enum ComponentType {
  hostname,
  ipAddress,
  url,
  port,
  service,
  parameter,
  path,
  other;
  
  String get displayName {
    switch (this) {
      case ComponentType.hostname:
        return 'Hostname';
      case ComponentType.ipAddress:
        return 'IP Address';
      case ComponentType.url:
        return 'URL';
      case ComponentType.port:
        return 'Port';
      case ComponentType.service:
        return 'Service';
      case ComponentType.parameter:
        return 'Parameter';
      case ComponentType.path:
        return 'Path';
      case ComponentType.other:
        return 'Other';
    }
  }
}

class FindingLink {
  final String id;
  final String findingId;
  final String title;
  final String url;
  final int orderIndex;
  final DateTime createdDate;
  
  FindingLink({
    required this.id,
    required this.findingId,
    required this.title,
    required this.url,
    this.orderIndex = 0,
    required this.createdDate,
  });
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
  };
  
  factory FindingLink.fromJson(Map<String, dynamic> json) => FindingLink(
    id: '',
    findingId: '',
    title: json['title'] ?? '',
    url: json['url'] ?? '',
    createdDate: DateTime.now(),
  );
}
```

## UI Components

### 1. Finding Card Widget
```dart
class FindingCard extends StatelessWidget {
  final Finding finding;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  // Follows wireframe card design with:
  // - Border radius: var(--radius-medium)
  // - Background: var(--bg-primary)
  // - Border: 1px solid var(--border-color)
  // - Hover elevation and transform
  // - Left border accent based on severity
}
```

### 2. Finding Header Widget
```dart
class FindingHeader extends StatelessWidget {
  final Finding finding;
  final bool showActions;
  
  // Contains:
  // - Severity badge with appropriate color
  // - Title with responsive typography
  // - Status indicator
  // - CVSS score chip
  // - Action buttons (edit, delete, duplicate)
}
```

### 3. Finding Form Widget
```dart
class FindingForm extends StatefulWidget {
  final Finding? finding;
  final String projectId;
  final Function(Finding) onSave;
  
  // Comprehensive form with tabs matching editor:
  // - Basic Info (title, description, severity, CVSS)
  // - Audit Steps 
  // - Components
  // - Screenshots
  // - Links
  // - Export/Validation
}
```

### 4. CVSS Calculator Dialog
```dart
class CVSSCalculatorDialog extends StatefulWidget {
  final String? initialVector;
  final Function(double score, String vector) onCalculated;
  
  // Interactive CVSS calculator matching existing editor
  // with wireframe styling
}
```

### 5. Finding Summary Widget
```dart
class FindingSummaryWidget extends StatelessWidget {
  final List<Finding> findings;
  
  // Summary cards showing:
  // - Total findings count
  // - Breakdown by severity 
  // - Highest CVSS score
  // - Status distribution
}
```

### 6. Finding Filters Widget
```dart
class FindingFiltersWidget extends StatefulWidget {
  final FindingFilters filters;
  final Function(FindingFilters) onFiltersChanged;
  
  // Filter options:
  // - Severity (multiselect)
  // - Status (multiselect)
  // - CVSS score range
  // - Date range
  // - Text search
}
```

### 7. Finding Table Widget
```dart
class FindingTableWidget extends StatelessWidget {
  final List<Finding> findings;
  final FindingSortConfig sortConfig;
  final Function(Finding) onRowTap;
  
  // Responsive table with:
  // - Sortable columns
  // - Severity color coding
  // - Mobile-friendly card layout
  // - Bulk selection capabilities
}
```

### 8. Template Selector Widget
```dart
class TemplateSelectorWidget extends StatefulWidget {
  final Function(FindingTemplate) onTemplateSelected;
  final Function(TemplateSelection) onTemplateApplied;
  
  // Features:
  // - Template dropdown with categories
  // - JSON template file import
  // - Template preview with description
  // - Built-in templates + custom templates
}
```

### 9. SubFinding Selection Widget
```dart
class SubFindingSelectionWidget extends StatefulWidget {
  final FindingTemplate template;
  final Set<int> selectedIndices;
  final Function(Set<int>) onSelectionChanged;
  
  // Features:
  // - Expandable subfinding cards
  // - Checkboxes for multi-selection
  // - CVSS score indicators
  // - Description previews
  // - Selection statistics (count, highest score, average)
  // - Apply selected button
}
```

### 10. Template Editor Widget
```dart
class TemplateEditorWidget extends StatefulWidget {
  final FindingTemplate? template;
  final Function(FindingTemplate) onSave;
  
  // Features:
  // - Template metadata editing
  // - SubFinding CRUD operations
  // - Screenshot placeholder management
  // - JSON preview and export
  // - Validation and testing
}
```

### 11. JSON Import/Export Widget
```dart
class JsonImportExportWidget extends StatelessWidget {
  final Function(String) onImportJson;
  final Function() onExportJson;
  final Function() onExportAllFindings;
  
  // Features:
  // - File picker for JSON import
  // - Template validation and parsing
  // - Bulk finding export
  // - Error handling and user feedback
}
```

### 12. Screenshot Placeholder Widget
```dart
class ScreenshotPlaceholderWidget extends StatelessWidget {
  final ScreenshotPlaceholder placeholder;
  final VoidCallback? onReplace;
  final VoidCallback? onRemove;
  
  // Features:
  // - Placeholder card with caption and steps
  // - Replace with actual screenshot
  // - Drag-and-drop support
  // - Subfinding association display
}
```

## Screen Layouts

### 1. Findings Screen (`/findings`)
```
├── Findings Header
│   ├── Page Title & Description
│   ├── New Finding Button (Primary)
│   └── Bulk Actions (Export, Delete)
├── Findings Summary Widget
├── Findings Filters Widget  
├── Findings Table/Cards
│   ├── Desktop: Table layout
│   └── Mobile: Card layout
└── Floating Action Button (New Finding)
```

### 2. Finding Detail Screen (`/findings/:id`)
```
├── Finding Header
│   ├── Back Button
│   ├── Finding Title & Severity Badge
│   ├── Status Selector
│   └── Actions (Edit, Delete, Duplicate)
├── Tab Navigation
│   ├── Overview Tab
│   │   ├── Description (Markdown)
│   │   ├── CVSS Details
│   │   ├── Components List
│   │   └── Status History
│   ├── Audit Guide Tab
│   │   ├── Audit Steps
│   │   ├── Automated Scripts
│   │   └── Verification Procedure
│   ├── Screenshots Tab
│   │   └── Screenshot Gallery
│   ├── References Tab
│   │   └── External Links
│   └── Export Tab
│       ├── Markdown Preview
│       ├── HTML Preview
│       └── Export Actions
└── Related Screenshots Section
```

### 3. Finding Editor Screen (`/findings/new` or `/findings/:id/edit`)
```
├── Editor Header
│   ├── Save Button (Primary)
│   ├── Preview Toggle
│   └── Cancel Button
├── Template Section (Collapsible)
│   ├── Template Selector Dropdown
│   ├── JSON File Import Button
│   ├── Template Info Panel
│   ├── SubFinding Selection (when template loaded)
│   │   ├── SubFinding Cards (with checkboxes)
│   │   ├── Selection Statistics
│   │   └── Apply Template Button
│   └── Clear Template Button
├── Editor Form (Tabbed)
│   ├── Basic Info Tab
│   │   ├── Title Input (populated from template)
│   │   ├── Description Editor (Markdown, populated from template)
│   │   ├── CVSS Calculator Integration
│   │   └── Severity Selector (auto-set from template)
│   ├── Audit Steps Tab
│   │   ├── Steps Editor (Markdown, populated from template)
│   │   ├── Script Editor (populated from template)
│   │   └── Verification Procedure Editor
│   ├── Components Tab
│   │   ├── Add Component Section
│   │   └── Components List
│   ├── Screenshots Tab
│   │   ├── Upload Area
│   │   ├── Screenshot Gallery (with placeholders from template)
│   │   ├── Screenshot Placeholders List
│   │   └── Screenshot Linking
│   └── References Tab
│       ├── Add Link Section
│       ├── Links List (populated from template)
│       └── Bulk Link Import
└── Live Preview Panel (Optional)
```

### 4. Template Management Screen (`/templates`)
```
├── Templates Header
│   ├── Page Title & Description
│   ├── New Template Button (Primary)
│   ├── Import Template Button
│   └── Export All Templates Button
├── Template Categories Filter
├── Templates Grid/List
│   ├── Desktop: Grid layout with template cards
│   ├── Mobile: List layout
│   ├── Template Card Components:
│   │   ├── Template Title & Category
│   │   ├── SubFindings Count Badge
│   │   ├── Built-in/Custom Indicator
│   │   ├── Last Updated Date
│   │   └── Actions (Edit, Export, Duplicate, Delete)
│   └── Empty State (when no templates)
└── Template Statistics Summary
```

### 5. Template Editor Screen (`/templates/new` or `/templates/:id/edit`)
```
├── Template Editor Header
│   ├── Save Button (Primary)
│   ├── Export JSON Button
│   └── Cancel Button
├── Template Basic Info
│   ├── Title Input
│   ├── Category Selector
│   ├── Base Description Editor (Markdown)
│   └── Automated Script Editor
├── SubFindings Management
│   ├── Add SubFinding Button
│   ├── SubFindings List
│   │   ├── SubFinding Cards (expandable)
│   │   ├── Drag-and-drop reordering
│   │   └── Individual SubFinding Editors
│   └── SubFinding Editor (Modal/Inline)
│       ├── Title & Description
│       ├── CVSS Calculator Integration
│       ├── Check Steps Editor
│       ├── Recommendation Editor
│       ├── Links Management
│       └── Screenshot Placeholders
└── JSON Preview Panel (Optional)
```

## Provider Architecture

### 1. Finding Provider
```dart
class FindingProvider extends StateNotifier<FindingState> {
  final DatabaseService _database;
  final ProjectProvider _projectProvider;
  final TemplateProvider _templateProvider;
  
  // State management for:
  // - Current findings list
  // - Active filters and sorting
  // - Loading states
  // - Error handling
  
  Future<void> loadFindings(String projectId);
  Future<Finding> createFinding(Finding finding);
  Future<Finding> updateFinding(Finding finding);
  Future<void> deleteFinding(String findingId);
  Future<void> bulkUpdateFindings(List<String> ids, Map<String, dynamic> updates);
  
  // Template-based finding creation
  Future<Finding> createFindingFromTemplate(String projectId, TemplateSelection selection);
  
  // Filter and sort methods
  void updateFilters(FindingFilters filters);
  void updateSort(FindingSortConfig sort);
  List<Finding> get filteredFindings;
  
  // Statistics methods
  FindingSummaryStats get summaryStats;
  Map<FindingSeverity, int> get severityBreakdown;
  Map<FindingStatus, int> get statusBreakdown;
  
  // Import/Export methods
  Future<void> exportFindings(List<String> findingIds, String filePath);
  Future<List<Finding>> importFindings(String jsonData, String projectId);
}
```

### 2. Template Provider
```dart
class TemplateProvider extends StateNotifier<TemplateState> {
  final DatabaseService _database;
  final FileService _fileService;
  
  // State management for:
  // - Available templates (built-in + custom)
  // - Template selection and application
  // - Loading states
  // - Error handling
  
  Future<void> loadTemplates();
  Future<void> loadBuiltInTemplates();
  Future<List<FindingTemplate>> loadCustomTemplates();
  Future<FindingTemplate> importTemplateFromJson(String jsonData);
  Future<FindingTemplate> importTemplateFromFile(File file);
  
  // Template CRUD operations
  Future<FindingTemplate> createTemplate(FindingTemplate template);
  Future<FindingTemplate> updateTemplate(FindingTemplate template);
  Future<void> deleteTemplate(String templateId);
  Future<FindingTemplate> duplicateTemplate(String templateId);
  
  // Template export/import
  Future<String> exportTemplateToJson(String templateId);
  Future<String> exportAllTemplatesToJson();
  Future<void> exportTemplateToFile(String templateId, String filePath);
  
  // Template selection management
  void selectTemplate(String templateId);
  void clearTemplateSelection();
  void toggleSubFinding(int index);
  void selectAllSubFindings();
  void clearSubFindingSelection();
  
  // Template application
  TemplateSelection? get currentSelection;
  bool get hasTemplateSelected;
  bool get hasSubFindingsSelected;
  
  // Categories and filtering
  List<String> get availableCategories;
  void filterByCategory(String? category);
  void searchTemplates(String query);
  
  // Built-in templates management
  Future<void> resetBuiltInTemplates();
  Future<void> updateBuiltInTemplates();
}
```

### 3. Finding State Models
```dart
class FindingState {
  final List<Finding> findings;
  final FindingFilters filters;
  final FindingSortConfig sortConfig;
  final bool isLoading;
  final String? error;
  final Finding? selectedFinding;
  
  FindingState({
    this.findings = const [],
    this.filters = const FindingFilters(),
    this.sortConfig = const FindingSortConfig(),
    this.isLoading = false,
    this.error,
    this.selectedFinding,
  });
}

class TemplateState {
  final List<FindingTemplate> templates;
  final List<FindingTemplate> builtInTemplates;
  final List<FindingTemplate> customTemplates;
  final String? selectedCategory;
  final String? searchQuery;
  final FindingTemplate? selectedTemplate;
  final Set<int> selectedSubFindings;
  final bool isLoading;
  final String? error;
  final TemplateSelection? currentSelection;
  
  TemplateState({
    this.templates = const [],
    this.builtInTemplates = const [],
    this.customTemplates = const [],
    this.selectedCategory,
    this.searchQuery,
    this.selectedTemplate,
    this.selectedSubFindings = const {},
    this.isLoading = false,
    this.error,
    this.currentSelection,
  });
  
  List<FindingTemplate> get filteredTemplates {
    var filtered = templates;
    
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      filtered = filtered.where((t) => t.category == selectedCategory).toList();
    }
    
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((t) => 
        t.title.toLowerCase().contains(query) ||
        t.category.toLowerCase().contains(query) ||
        t.baseDescription.toLowerCase().contains(query)
      ).toList();
    }
    
    return filtered;
  }
  
  List<String> get availableCategories {
    return templates.map((t) => t.category).toSet().toList()..sort();
  }
}

class FindingFilters {
  final List<FindingSeverity> severities;
  final List<FindingStatus> statuses;
  final double? minCvssScore;
  final double? maxCvssScore;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;
  
  const FindingFilters({
    this.severities = const [],
    this.statuses = const [],
    this.minCvssScore,
    this.maxCvssScore,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });
}

class FindingSortConfig {
  final FindingSortField field;
  final SortDirection direction;
  
  const FindingSortConfig({
    this.field = FindingSortField.updatedDate,
    this.direction = SortDirection.desc,
  });
}

enum FindingSortField {
  title,
  severity,
  cvssScore,
  status,
  createdDate,
  updatedDate,
}
```

## Feature Requirements

### Core Features
1. **Finding Management**
   - ✅ Create, read, update, delete findings
   - ✅ Bulk operations (status updates, deletion)
   - ✅ Finding duplication with template system
   - ✅ Multi-tab finding editor interface
   - ✅ Multi-finding management with tabs

2. **CVSS Integration**
   - ✅ Interactive CVSS 3.1 calculator
   - ✅ Vector string parsing and generation
   - ✅ Automatic severity assignment based on score
   - ✅ Score validation and constraints
   - ✅ Vector input and parsing from templates

3. **Component Management**
   - ✅ Multiple component types (hostname, IP, URL, etc.)
   - ✅ Dynamic component addition/removal
   - ✅ Component validation and formatting

4. **Screenshot Integration**
   - ✅ Link screenshots to findings
   - ✅ Screenshot annotation support
   - ✅ Drag-and-drop screenshot upload
   - ✅ Screenshot gallery and preview
   - ✅ Screenshot placeholders from templates
   - ✅ SubFinding-specific screenshot organization

5. **Export Capabilities**
   - ✅ Markdown export with templates
   - ✅ HTML export with styling
   - ✅ Bulk finding export
   - ✅ Template import/export system
   - ✅ JSON-based template format
   - ✅ Cross-platform template sharing

### Advanced Template System
1. **SubFinding Architecture**
   - ✅ Multiple sub-findings per template
   - ✅ Individual CVSS scoring per sub-finding
   - ✅ Selective sub-finding application
   - ✅ Sub-finding specific check steps
   - ✅ Individual recommendations per sub-finding
   - ✅ Sub-finding specific screenshot placeholders
   - ✅ Sub-finding reference links

2. **JSON Template System**
   - ✅ Standardized JSON template format
   - ✅ Template file import/export
   - ✅ Built-in template library
   - ✅ Custom template creation
   - ✅ Template validation and error handling
   - ✅ Template versioning support
   - ✅ Folder-based template organization
   - ✅ Legacy template format support

3. **Template Selection Interface**
   - ✅ Template browser with categories
   - ✅ Multi-select sub-finding interface
   - ✅ Real-time selection statistics
   - ✅ Expandable sub-finding preview
   - ✅ CVSS score calculation from selection
   - ✅ Template application with merge logic
   - ✅ Clear and reset functionality

4. **Screenshot Placeholder System**
   - ✅ Placeholder generation from templates
   - ✅ Step-by-step screenshot instructions
   - ✅ Placeholder replacement workflow
   - ✅ Sub-finding association tracking
   - ✅ Bulk placeholder management
   - ✅ Screenshot-to-finding linking

### Advanced Features
1. **Template Management**
   - ✅ Template CRUD operations
   - ✅ Template duplication and cloning
   - ✅ Category-based organization
   - ✅ Template search and filtering
   - ✅ Built-in vs. custom template separation
   - ✅ Template sharing and collaboration

2. **Audit Workflow**
   - ✅ Audit step templates
   - ✅ Automated script integration
   - ✅ Verification procedures
   - ✅ Step-by-step guidance
   - ✅ Template-driven audit processes
   - ✅ Multi-level finding validation

3. **Import/Export System**
   - ✅ JSON template import/export
   - ✅ Bulk finding export
   - ✅ Finding collection management
   - ✅ Cross-project template sharing
   - ✅ Template library synchronization
   - ✅ Backup and restore functionality

4. **Multi-Finding Editor**
   - ✅ Tabbed finding interface
   - ✅ Finding statistics dashboard
   - ✅ Cross-finding navigation
   - ✅ Bulk finding operations
   - ✅ Finding lifecycle management
   - ✅ Multi-finding export

5. **Collaboration Features**
   - 🔄 Finding comments and notes
   - 🔄 Status change history
   - 🔄 Assignment and ownership
   - 🔄 Review workflows
   - 🔄 Template sharing workflows

6. **Integration Points**
   - ✅ Project association
   - ✅ Screenshot linking
   - ✅ Template-screenshot integration
   - 🔄 Task integration
   - 🔄 Reporting integration

Legend: ✅ Planned, 🔄 Future Enhancement

## Integration Points

### 1. Project Integration
- Findings scoped to specific projects
- Project statistics updated with finding counts
- Project-level finding templates and workflows

### 2. Screenshot Integration  
- Link findings to screenshots for evidence
- Screenshot annotations tied to specific findings
- Automatic screenshot organization by finding

### 3. Task Integration
- Create tasks from findings for remediation tracking
- Link verification tasks to findings
- Task completion updates finding status

### 4. Reporting Integration
- Include findings in project reports
- Export findings in multiple formats
- Template-based finding descriptions

### 5. Navigation Integration
- Add "Findings" to side navigation
- Finding counts in dashboard summaries  
- Quick finding creation from other screens

## Implementation Phases

### Phase 1: Core Infrastructure (Week 1-2)
- [ ] Database schema implementation (all tables including templates/subfindings)
- [ ] Core Flutter models (Finding, Template, SubFinding)
- [ ] Basic provider architecture (FindingProvider, TemplateProvider)
- [ ] Navigation integration
- [ ] JSON serialization/deserialization

### Phase 2: Basic CRUD Operations (Week 3-4)  
- [ ] Findings list screen with multi-finding tabs
- [ ] Basic finding form
- [ ] Finding detail view
- [ ] Simple filtering and sorting
- [ ] Finding statistics dashboard

### Phase 3: Template System Foundation (Week 5-6)
- [ ] Template management screens
- [ ] Built-in template loading
- [ ] JSON template import/export
- [ ] Template CRUD operations
- [ ] Basic template selection interface

### Phase 4: SubFinding Integration (Week 7-8)
- [ ] SubFinding selection interface
- [ ] Multi-select functionality with statistics
- [ ] Template application workflow
- [ ] SubFinding-specific data merging
- [ ] CVSS score calculation from selection

### Phase 5: Enhanced Editor with Templates (Week 9-10)
- [ ] Multi-tab finding editor with template integration
- [ ] CVSS calculator integration
- [ ] Component management
- [ ] Template-driven form population
- [ ] Real-time template preview

### Phase 6: Screenshot Placeholder System (Week 11-12)
- [ ] Screenshot placeholder generation
- [ ] Placeholder-to-screenshot replacement
- [ ] SubFinding-specific screenshot organization
- [ ] Screenshot gallery with template context
- [ ] Bulk placeholder management

### Phase 7: Advanced Template Features (Week 13-14)
- [ ] Template editor interface
- [ ] SubFinding management (create, edit, delete)
- [ ] Template categories and search
- [ ] Template duplication and sharing
- [ ] Advanced JSON template validation

### Phase 8: Export & Import Systems (Week 15-16)
- [ ] Multi-format export (Markdown, HTML, JSON)
- [ ] Bulk finding export with template context
- [ ] Template library synchronization
- [ ] Cross-project template sharing
- [ ] Backup and restore functionality

### Phase 9: Multi-Finding Management (Week 17-18)
- [ ] Tabbed finding interface
- [ ] Cross-finding navigation
- [ ] Bulk operations across findings
- [ ] Finding lifecycle management
- [ ] Multi-finding statistics

### Phase 10: Polish & Testing (Week 19-20)
- [ ] Responsive design refinement
- [ ] Performance optimization for large datasets
- [ ] Comprehensive testing (unit, integration, e2e)
- [ ] Documentation completion
- [ ] Template library curation

## Technical Considerations

### Performance
- Lazy loading for large finding lists
- Efficient filtering with database queries
- Image optimization for screenshots
- Pagination for better UX

### Security
- Input validation and sanitization
- SQL injection prevention
- File upload security
- XSS prevention in markdown rendering

### Accessibility
- Keyboard navigation support
- Screen reader compatibility
- High contrast mode support
- Focus management in modals

### Responsive Design
- Mobile-first approach
- Breakpoint-based layouts
- Touch-friendly interfaces
- Progressive enhancement

## JSON Template Format Specification

### Template File Structure
```json
{
  "templates": [
    {
      "id": "unique-template-id",
      "title": "Template Display Name",
      "category": "Category Name",
      "baseDescription": "Base description that applies to all subfindings",
      "automatedScript": "Optional PowerShell/Bash script for automated checks",
      "subFindings": [
        {
          "id": "unique-subfinding-id-within-template",
          "title": "SubFinding Title",
          "cvssScore": 7.5,
          "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N",
          "severity": "High",
          "description": "Detailed description of the specific vulnerability",
          "checkSteps": "Step-by-step instructions for identifying this issue:\n1. Navigate to...\n2. Check for...\n3. Screenshot...",
          "recommendation": "Specific remediation steps for this subfinding",
          "verificationProcedure": "Optional steps to verify remediation",
          "links": [
            {
              "title": "Reference Link Title",
              "url": "https://example.com/reference"
            }
          ],
          "screenshotPlaceholders": [
            {
              "caption": "Screenshot description/caption",
              "steps": "Specific steps to take this screenshot:\n1. Navigate to...\n2. Highlight...\n3. Capture..."
            }
          ]
        }
      ]
    }
  ]
}
```

### Built-in Template Categories
- **Cloud Security** - AWS, Azure, GCP misconfigurations
- **Web Application** - Common web vulnerabilities
- **Network Security** - Network-level vulnerabilities
- **Active Directory** - AD/LDAP security issues
- **Database Security** - Database configuration issues
- **Mobile Security** - Mobile app vulnerabilities
- **Infrastructure** - Server and system configurations

### Template Validation Rules
1. **Required Fields**: `id`, `title`, `category`, `baseDescription`, `subFindings`
2. **SubFinding Requirements**: `id`, `title`, `cvssScore`, `cvssVector`, `severity`, `description`, `checkSteps`, `recommendation`
3. **CVSS Score**: Must be between 0.0 and 10.0
4. **CVSS Vector**: Must be valid CVSS 3.1 format
5. **Severity**: Must match calculated severity from CVSS score
6. **IDs**: Must be unique within their scope (template ID globally, subfinding ID within template)

### Migration from Existing Editor
The current finding editor uses this exact JSON format, ensuring seamless compatibility:

1. **Template Import**: Direct JSON file import with validation
2. **Built-in Templates**: Embedded templates in application assets
3. **Legacy Support**: Backward compatibility with existing template files
4. **Export Compatibility**: Generated templates work in both systems

### Template Distribution
- **Built-in Library**: Curated professional templates included with app
- **User Templates**: Custom templates stored in user database
- **Shared Templates**: JSON files for team sharing
- **Template Marketplace**: Future expansion for community templates

This comprehensive specification provides the foundation for implementing a robust findings management system that integrates seamlessly with the existing Madness application architecture while maintaining full compatibility with the existing finding editor's advanced template and subfinding functionality.