/// Integrated scope confirmation widget that uses existing scope models
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/scope.dart';
import '../../models/questionnaire.dart';
import '../../providers/scope_provider.dart';
import '../../providers/projects_provider.dart';
import '../../widgets/scope_segment_card_widget.dart';
import '../../constants/app_spacing.dart';
import 'question_widget_base.dart';

class IntegratedScopeConfirmationWidget extends ConsumerStatefulWidget {
  final QuestionDefinition question;
  final QuestionAnswer? answer;
  final QuestionAnswerCallback onAnswerChanged;

  const IntegratedScopeConfirmationWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
  });

  @override
  ConsumerState<IntegratedScopeConfirmationWidget> createState() => _IntegratedScopeConfirmationWidgetState();
}

class _IntegratedScopeConfirmationWidgetState extends ConsumerState<IntegratedScopeConfirmationWidget> {
  static const _uuid = Uuid();
  List<ScopeSegment> _previewSegments = [];
  bool _isConfirmed = false;

  // Mapping from questionnaire elements to scope segment types
  static const Map<String, ScopeSegmentType> _elementTypeMapping = {
    'external_infrastructure': ScopeSegmentType.external,
    'internal_network': ScopeSegmentType.internal,
    'web_applications': ScopeSegmentType.webapp,
    'mobile_app': ScopeSegmentType.mobile,
    'wireless': ScopeSegmentType.wireless,
    'api_testing': ScopeSegmentType.api,
    'cloud_services': ScopeSegmentType.cloud,
    'active_directory': ScopeSegmentType.activeDirectory,
    'iot_devices': ScopeSegmentType.iot,
  };

  // Default scope items for each segment type
  static const Map<ScopeSegmentType, List<Map<String, dynamic>>> _defaultScopeItems = {
    ScopeSegmentType.external: [
      {'target': 'Web Servers', 'type': ScopeItemType.host, 'description': 'Public-facing web servers'},
      {'target': 'Mail Servers', 'type': ScopeItemType.host, 'description': 'Email infrastructure'},
      {'target': 'DNS Servers', 'type': ScopeItemType.host, 'description': 'Domain name servers'},
      {'target': 'Public APIs', 'type': ScopeItemType.url, 'description': 'External API endpoints'},
    ],
    ScopeSegmentType.internal: [
      {'target': 'Domain Controllers', 'type': ScopeItemType.host, 'description': 'Active Directory controllers'},
      {'target': 'File Servers', 'type': ScopeItemType.host, 'description': 'Network file storage'},
      {'target': 'Database Servers', 'type': ScopeItemType.host, 'description': 'Database infrastructure'},
      {'target': 'Workstations', 'type': ScopeItemType.network, 'description': 'User workstation network'},
    ],
    ScopeSegmentType.webapp: [
      {'target': 'Customer Portal', 'type': ScopeItemType.url, 'description': 'Primary customer interface'},
      {'target': 'Admin Interface', 'type': ScopeItemType.url, 'description': 'Administrative panel'},
      {'target': 'API Endpoints', 'type': ScopeItemType.url, 'description': 'Web application APIs'},
      {'target': 'Mobile App Backend', 'type': ScopeItemType.url, 'description': 'Mobile application services'},
    ],
    ScopeSegmentType.mobile: [
      {'target': 'iOS App', 'type': ScopeItemType.host, 'description': 'Native iOS application'},
      {'target': 'Android App', 'type': ScopeItemType.host, 'description': 'Native Android application'},
      {'target': 'Mobile API', 'type': ScopeItemType.url, 'description': 'Mobile-specific APIs'},
      {'target': 'Device Storage', 'type': ScopeItemType.host, 'description': 'Local device data storage'},
    ],
    ScopeSegmentType.wireless: [
      {'target': 'WiFi Networks', 'type': ScopeItemType.network, 'description': 'Wireless network infrastructure'},
      {'target': 'Guest Networks', 'type': ScopeItemType.network, 'description': 'Guest access points'},
      {'target': 'IoT Devices', 'type': ScopeItemType.host, 'description': 'Internet of Things devices'},
      {'target': 'Bluetooth Services', 'type': ScopeItemType.host, 'description': 'Bluetooth-enabled devices'},
    ],
    ScopeSegmentType.api: [
      {'target': 'REST APIs', 'type': ScopeItemType.url, 'description': 'RESTful web services'},
      {'target': 'GraphQL Endpoints', 'type': ScopeItemType.url, 'description': 'GraphQL query interfaces'},
      {'target': 'SOAP Services', 'type': ScopeItemType.url, 'description': 'SOAP web services'},
      {'target': 'Webhooks', 'type': ScopeItemType.url, 'description': 'Webhook endpoints'},
    ],
    ScopeSegmentType.cloud: [
      {'target': 'AWS Resources', 'type': ScopeItemType.host, 'description': 'Amazon Web Services'},
      {'target': 'Azure Resources', 'type': ScopeItemType.host, 'description': 'Microsoft Azure services'},
      {'target': 'Cloud Storage', 'type': ScopeItemType.host, 'description': 'Cloud storage buckets'},
      {'target': 'Container Services', 'type': ScopeItemType.host, 'description': 'Containerized applications'},
    ],
    ScopeSegmentType.activeDirectory: [
      {'target': 'Domain Users', 'type': ScopeItemType.host, 'description': 'Active Directory user accounts'},
      {'target': 'Group Policies', 'type': ScopeItemType.host, 'description': 'AD group policy objects'},
      {'target': 'Certificate Services', 'type': ScopeItemType.host, 'description': 'PKI certificate authority'},
      {'target': 'LDAP Services', 'type': ScopeItemType.host, 'description': 'LDAP directory services'},
    ],
    ScopeSegmentType.iot: [
      {'target': 'Smart Sensors', 'type': ScopeItemType.host, 'description': 'IoT sensor devices'},
      {'target': 'Control Systems', 'type': ScopeItemType.host, 'description': 'Industrial control systems'},
      {'target': 'Network Cameras', 'type': ScopeItemType.host, 'description': 'IP security cameras'},
      {'target': 'Environmental Controls', 'type': ScopeItemType.host, 'description': 'HVAC and lighting systems'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeScopeFromProject();
  }

  void _initializeScopeFromProject() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = ProviderScope.containerOf(context).read(currentProjectProvider);
      if (project != null) {
        // Initialize preview segments based on project assessment scope
        _updatePreviewSegments(project.assessmentScope);
      } else {
        // Initialize with empty segments
        _previewSegments = [];
      }
      setState(() {});
    });
  }

  void _updatePreviewSegments(Map<String, bool> assessmentScope) {
    final segments = <ScopeSegment>[];

    for (final entry in assessmentScope.entries) {
      if (entry.value && _elementTypeMapping.containsKey(entry.key)) {
        final segmentType = _elementTypeMapping[entry.key]!;
        final defaultItems = _defaultScopeItems[segmentType] ?? [];

        final scopeItems = defaultItems.map((itemData) {
          return ScopeItem(
            id: _uuid.v4(),
            type: itemData['type'] as ScopeItemType,
            target: itemData['target'] as String,
            description: itemData['description'] as String,
            dateAdded: DateTime.now(),
            isActive: true,
          );
        }).toList();

        segments.add(ScopeSegment(
          id: _uuid.v4(),
          title: segmentType.displayName,
          type: segmentType,
          status: ScopeSegmentStatus.planned,
          items: scopeItems,
          description: 'Assessment scope for ${segmentType.displayName.toLowerCase()}',
        ));
      }
    }

    _previewSegments = segments;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scopeSegments = ref.watch(filteredScopeSegmentsProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with pill summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.checklist,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    AppSpacing.hGapMD,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scope Confirmation & Updates',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Review and update engagement scope segments',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapMD,
                _buildPillStyleSummary(context),
              ],
            ),
          ),

          // Scope segments preview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Scope Segments',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (scopeSegments.isNotEmpty)
                      TextButton.icon(
                        onPressed: _loadExistingScope,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Load Existing'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                AppSpacing.vGapMD,

                if (_previewSegments.isEmpty)
                  _buildEmptyState(context)
                else
                  ..._previewSegments.map((segment) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ScopeSegmentCardWidget(segment: segment),
                    ),
                  ),

                AppSpacing.vGapLG,

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previewSegments.isNotEmpty ? _updateScope : null,
                        icon: const Icon(Icons.update),
                        label: const Text('Update Scope'),
                      ),
                    ),
                    AppSpacing.hGapMD,
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _previewSegments.isNotEmpty ? _confirmScope : null,
                        icon: Icon(_isConfirmed ? Icons.check_circle : Icons.check),
                        label: Text(_isConfirmed ? 'Confirmed' : 'Confirm Scope'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isConfirmed ? Colors.green : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillStyleSummary(BuildContext context) {
    final stats = _calculateScopeStats();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatChip('Total', stats.total, Icons.track_changes, Theme.of(context).primaryColor),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('External', stats.external, Icons.public, Colors.teal),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('Internal', stats.internal, Icons.business, Colors.blue),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('Web App', stats.webapp, Icons.web, Colors.green),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('Mobile', stats.mobile, Icons.phone_android, Colors.orange),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('API', stats.api, Icons.api, Colors.red),
          const SizedBox(width: AppSpacing.sm),
          _buildStatChip('Items', stats.totalItems, Icons.list, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.vGapMD,
          Text(
            'No scope segments configured',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.vGapSM,
          Text(
            'Configure assessment scope in project settings to see segments here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  ScopeStats _calculateScopeStats() {
    final external = _previewSegments.where((s) => s.type == ScopeSegmentType.external).length;
    final internal = _previewSegments.where((s) => s.type == ScopeSegmentType.internal).length;
    final webapp = _previewSegments.where((s) => s.type == ScopeSegmentType.webapp).length;
    final mobile = _previewSegments.where((s) => s.type == ScopeSegmentType.mobile).length;
    final api = _previewSegments.where((s) => s.type == ScopeSegmentType.api).length;
    final totalItems = _previewSegments.fold<int>(0, (sum, s) => sum + s.totalItemsCount);

    return ScopeStats(
      total: _previewSegments.length,
      external: external,
      internal: internal,
      webapp: webapp,
      mobile: mobile,
      api: api,
      wireless: _previewSegments.where((s) => s.type == ScopeSegmentType.wireless).length,
      totalItems: totalItems,
    );
  }

  void _loadExistingScope() {
    final existingSegments = ref.read(filteredScopeSegmentsProvider);
    setState(() {
      _previewSegments = List.from(existingSegments);
    });
    _updateAnswer();
  }

  Future<void> _updateScope() async {
    final scopeNotifier = ref.read(scopeProvider.notifier);
    final projectsNotifier = ref.read(projectsProvider.notifier);
    final currentProject = ref.read(currentProjectProvider);

    try {
      // Add preview segments to the database (they will persist now)
      for (final segment in _previewSegments) {
        await scopeNotifier.addSegment(segment);
      }

      // Update project assessment scope based on segments
      if (currentProject != null) {
        final updatedAssessmentScope = <String, bool>{};

        // Map segments back to assessment scope elements
        for (final segment in _previewSegments) {
          final elementType = _segmentTypeToElementType(segment.type);
          if (elementType != null) {
            updatedAssessmentScope[elementType] = true;
          }
        }

        // Update the project with new assessment scope
        final updatedProject = currentProject.copyWith(
          assessmentScope: updatedAssessmentScope,
          updatedDate: DateTime.now(),
        );

        await projectsNotifier.updateProject(updatedProject);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated ${_previewSegments.length} scope segments and project scope'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      _updateAnswer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating scope: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _confirmScope() async {
    final scopeNotifier = ref.read(scopeProvider.notifier);
    final projectsNotifier = ref.read(projectsProvider.notifier);
    final currentProject = ref.read(currentProjectProvider);

    setState(() {
      _isConfirmed = true;
    });

    try {
      // Add scope segments to database first
      for (final segment in _previewSegments) {
        await scopeNotifier.addSegment(segment);
      }

      // Update project assessment scope when confirming
      if (currentProject != null) {
        final updatedAssessmentScope = <String, bool>{};

        // Map segments back to assessment scope elements
        for (final segment in _previewSegments) {
          final elementType = _segmentTypeToElementType(segment.type);
          if (elementType != null) {
            updatedAssessmentScope[elementType] = true;
          }
        }

        // Update the project with new assessment scope
        final updatedProject = currentProject.copyWith(
          assessmentScope: updatedAssessmentScope,
          updatedDate: DateTime.now(),
        );

        await projectsNotifier.updateProject(updatedProject);
      }

      widget.onAnswerChanged(
        widget.question.id,
        {
          'segments': _previewSegments.map((s) => {
            'id': s.id,
            'title': s.title,
            'type': s.type.name,
            'status': s.status.name,
            'itemCount': s.totalItemsCount,
          }).toList(),
          'confirmed': true,
          'timestamp': DateTime.now().toIso8601String(),
          'totalSegments': _previewSegments.length,
          'totalItems': _previewSegments.fold<int>(0, (sum, s) => sum + s.totalItemsCount),
        },
        QuestionStatus.completed,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scope confirmed and project updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error confirming scope: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateAnswer() {
    widget.onAnswerChanged(
      widget.question.id,
      {
        'segments': _previewSegments.map((s) => {
          'id': s.id,
          'title': s.title,
          'type': s.type.name,
          'status': s.status.name,
          'itemCount': s.totalItemsCount,
        }).toList(),
        'confirmed': _isConfirmed,
        'totalSegments': _previewSegments.length,
        'totalItems': _previewSegments.fold<int>(0, (sum, s) => sum + s.totalItemsCount),
      },
      _isConfirmed ? QuestionStatus.completed : QuestionStatus.inProgress,
    );
  }

  /// Map scope segment type back to element type for project assessment scope
  String? _segmentTypeToElementType(ScopeSegmentType segmentType) {
    final reverseMapping = <ScopeSegmentType, String>{
      ScopeSegmentType.external: 'external_infrastructure',
      ScopeSegmentType.internal: 'internal_network',
      ScopeSegmentType.webapp: 'web_applications',
      ScopeSegmentType.mobile: 'mobile_app',
      ScopeSegmentType.wireless: 'wireless',
      ScopeSegmentType.api: 'api',
      ScopeSegmentType.cloud: 'cloud_services',
      ScopeSegmentType.activeDirectory: 'active_directory',
      ScopeSegmentType.iot: 'iot_devices',
    };

    return reverseMapping[segmentType];
  }
}

class ScopeStats {
  final int total;
  final int external;
  final int internal;
  final int webapp;
  final int mobile;
  final int api;
  final int wireless;
  final int totalItems;

  ScopeStats({
    required this.total,
    required this.external,
    required this.internal,
    required this.webapp,
    required this.mobile,
    required this.api,
    required this.wireless,
    required this.totalItems,
  });
}