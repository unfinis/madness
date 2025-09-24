/// Advanced date-time picker widget for project scheduling and timeline management
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import 'question_widget_base.dart';

class ProjectDatesQuestionWidget extends QuestionWidgetBase {
  const ProjectDatesQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<ProjectDatesQuestionWidget> createState() => _ProjectDatesQuestionWidgetState();
}

class _ProjectDatesQuestionWidgetState extends QuestionWidgetBaseState<ProjectDatesQuestionWidget> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _timeWindow = 'business_hours';
  bool _weekendTesting = false;
  bool _outOfHoursNotifications = true;
  
  final Map<String, DateTime?> _milestones = {};
  final List<String> _phases = [];

  static const Map<String, String> _timeWindows = {
    'business_hours': 'Business Hours (9AM-5PM)',
    'extended_hours': 'Extended Hours (8AM-8PM)',
    'flexible': 'Flexible (Any Time)',
    'custom': 'Custom Schedule',
  };

  static const List<String> _defaultPhases = [
    'Scoping & Planning',
    'Reconnaissance',
    'Vulnerability Assessment',
    'Penetration Testing',
    'Reporting & Remediation',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeFromProject();
    _loadAnswerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeFromProject() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = ProviderScope.containerOf(context).read(currentProjectProvider);
      if (project != null) {
        setState(() {
          _startDate = project.startDate;
          _endDate = project.endDate;
          _phases.addAll(_defaultPhases);
        });
      }
    });
  }

  void _loadAnswerData() {
    if (widget.answer?.answer is Map) {
      final data = widget.answer!.answer as Map<String, dynamic>;
      setState(() {
        if (data['startDate'] != null) {
          _startDate = DateTime.parse(data['startDate']);
        }
        if (data['endDate'] != null) {
          _endDate = DateTime.parse(data['endDate']);
        }
        if (data['startTime'] != null) {
          final time = data['startTime'] as Map<String, dynamic>;
          _startTime = TimeOfDay(hour: time['hour'], minute: time['minute']);
        }
        if (data['endTime'] != null) {
          final time = data['endTime'] as Map<String, dynamic>;
          _endTime = TimeOfDay(hour: time['hour'], minute: time['minute']);
        }
        _timeWindow = data['timeWindow'] ?? 'business_hours';
        _weekendTesting = data['weekendTesting'] ?? false;
        _outOfHoursNotifications = data['outOfHoursNotifications'] ?? true;
        
        if (data['milestones'] is Map) {
          final milestones = data['milestones'] as Map<String, dynamic>;
          _milestones.clear();
          milestones.forEach((key, value) {
            _milestones[key] = value != null ? DateTime.parse(value) : null;
          });
        }
        
        if (data['phases'] is List) {
          _phases.clear();
          _phases.addAll(List<String>.from(data['phases']));
        }
      });
    }
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Testing Schedule & Timeline',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Configure testing dates, phases, and communication windows',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSummaryCard(context),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.event), text: 'Dates'),
              Tab(icon: Icon(Icons.access_time), text: 'Schedule'),
              Tab(icon: Icon(Icons.timeline), text: 'Phases'),
            ],
          ),
          
          // Tab Content
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDatesTab(context),
                _buildScheduleTab(context),
                _buildPhasesTab(context),
              ],
            ),
          ),
          
          // Footer Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetToDefaults,
                    child: const Text('Reset to Defaults'),
                  ),
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: FilledButton(
                    onPressed: _hasValidDates() ? _confirmSchedule : null,
                    child: const Text('Confirm Schedule'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _startDate != null && _endDate != null
        ? _endDate!.difference(_startDate!).inDays
        : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$duration',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Days',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_phases.length} Phases',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Testing Period',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapMD,
          
          // Date Range Picker
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  'Start Date',
                  _startDate,
                  Icons.event,
                  (date) => setState(() {
                    _startDate = date;
                    _updateAnswer();
                  }),
                ),
              ),
              AppSpacing.hGapMD,
              Expanded(
                child: _buildDateField(
                  context,
                  'End Date',
                  _endDate,
                  Icons.event,
                  (date) => setState(() {
                    _endDate = date;
                    _updateAnswer();
                  }),
                  firstDate: _startDate,
                ),
              ),
            ],
          ),
          
          AppSpacing.vGapLG,
          
          Text(
            'Key Milestones',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapMD,
          
          // Milestones
          ..._buildMilestones(context),
          
          AppSpacing.vGapMD,
          
          TextButton.icon(
            onPressed: _addMilestone,
            icon: const Icon(Icons.add),
            label: const Text('Add Milestone'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Communication Windows',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapMD,
          
          // Time Window Selection
          DropdownButtonFormField<String>(
            value: _timeWindow,
            decoration: const InputDecoration(
              labelText: 'Preferred Communication Window',
              border: OutlineInputBorder(),
            ),
            items: _timeWindows.entries.map((entry) =>
              DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            ).toList(),
            onChanged: (value) => setState(() {
              _timeWindow = value!;
              _updateAnswer();
            }),
          ),
          
          AppSpacing.vGapMD,
          
          // Custom time range (if custom selected)
          if (_timeWindow == 'custom') ...[
            Row(
              children: [
                Expanded(
                  child: _buildTimeField(
                    context,
                    'Start Time',
                    _startTime,
                    (time) => setState(() {
                      _startTime = time;
                      _updateAnswer();
                    }),
                  ),
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: _buildTimeField(
                    context,
                    'End Time',
                    _endTime,
                    (time) => setState(() {
                      _endTime = time;
                      _updateAnswer();
                    }),
                  ),
                ),
              ],
            ),
            AppSpacing.vGapMD,
          ],
          
          // Options
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Weekend Testing Allowed'),
                  subtitle: const Text('Enable testing activities on weekends'),
                  value: _weekendTesting,
                  onChanged: (value) => setState(() {
                    _weekendTesting = value;
                    _updateAnswer();
                  }),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Out of Hours Notifications'),
                  subtitle: const Text('Receive notifications outside business hours'),
                  value: _outOfHoursNotifications,
                  onChanged: (value) => setState(() {
                    _outOfHoursNotifications = value;
                    _updateAnswer();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhasesTab(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Testing Phases',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addPhase,
                icon: const Icon(Icons.add),
                label: const Text('Add Phase'),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _phases.removeAt(oldIndex);
                  _phases.insert(newIndex, item);
                  _updateAnswer();
                });
              },
              children: _phases.asMap().entries.map((entry) {
                final index = entry.key;
                final phase = entry.value;
                
                return Card(
                  key: ValueKey(phase),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(phase),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.drag_handle,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removePhase(index),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? value,
    IconData icon,
    Function(DateTime?) onChanged, {
    DateTime? firstDate,
  }) {
    return InkWell(
      onTap: () => _selectDate(context, value, onChanged, firstDate: firstDate),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        child: Text(
          value != null
              ? '${value.day}/${value.month}/${value.year}'
              : 'Select date',
          style: value != null ? null : TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(
    BuildContext context,
    String label,
    TimeOfDay? value,
    Function(TimeOfDay?) onChanged,
  ) {
    return InkWell(
      onTap: () => _selectTime(context, value, onChanged),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          value != null
              ? value.format(context)
              : 'Select time',
          style: value != null ? null : TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMilestones(BuildContext context) {
    return _milestones.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                entry.key,
                entry.value,
                Icons.flag,
                (date) => setState(() {
                  _milestones[entry.key] = date;
                  _updateAnswer();
                }),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(() {
                _milestones.remove(entry.key);
                _updateAnswer();
              }),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? currentValue,
    Function(DateTime?) onChanged, {
    DateTime? firstDate,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    onChanged(date);
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? currentValue,
    Function(TimeOfDay?) onChanged,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentValue ?? TimeOfDay.now(),
    );
    onChanged(time);
  }

  void _addMilestone() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Milestone'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Milestone Name',
            hintText: 'e.g., "Interim Report Due"',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _milestones[name] = null;
                  _updateAnswer();
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addPhase() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Phase'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Phase Name',
            hintText: 'e.g., "Web Application Testing"',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _phases.add(name);
                  _updateAnswer();
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removePhase(int index) {
    setState(() {
      _phases.removeAt(index);
      _updateAnswer();
    });
  }

  void _resetToDefaults() {
    final project = ProviderScope.containerOf(context).read(currentProjectProvider);
    
    setState(() {
      _startDate = project?.startDate;
      _endDate = project?.endDate;
      _startTime = null;
      _endTime = null;
      _timeWindow = 'business_hours';
      _weekendTesting = false;
      _outOfHoursNotifications = true;
      _milestones.clear();
      _phases.clear();
      _phases.addAll(_defaultPhases);
      _updateAnswer();
    });
  }

  bool _hasValidDates() {
    return _startDate != null && _endDate != null && _endDate!.isAfter(_startDate!);
  }

  void _confirmSchedule() {
    updateAnswer({
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'startTime': _startTime != null ? {'hour': _startTime!.hour, 'minute': _startTime!.minute} : null,
      'endTime': _endTime != null ? {'hour': _endTime!.hour, 'minute': _endTime!.minute} : null,
      'timeWindow': _timeWindow,
      'weekendTesting': _weekendTesting,
      'outOfHoursNotifications': _outOfHoursNotifications,
      'milestones': _milestones.map((key, value) => MapEntry(key, value?.toIso8601String())),
      'phases': _phases,
      'confirmed': true,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _updateAnswer() {
    updateAnswer({
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'startTime': _startTime != null ? {'hour': _startTime!.hour, 'minute': _startTime!.minute} : null,
      'endTime': _endTime != null ? {'hour': _endTime!.hour, 'minute': _endTime!.minute} : null,
      'timeWindow': _timeWindow,
      'weekendTesting': _weekendTesting,
      'outOfHoursNotifications': _outOfHoursNotifications,
      'milestones': _milestones.map((key, value) => MapEntry(key, value?.toIso8601String())),
      'phases': _phases,
      'confirmed': false,
    });
  }
}