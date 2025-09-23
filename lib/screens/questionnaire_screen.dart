/// Pre-engagement questionnaire screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/questionnaire.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/questionnaire/question_widget_factory.dart';
import '../constants/app_spacing.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize questionnaire session when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questionnaireNotifierProvider.notifier).initializeSession();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProject = ref.watch(currentProjectProvider);
    final questionnaireState = ref.watch(questionnaireNotifierProvider);
    final statistics = ref.watch(sessionStatisticsProvider);
    final progress = ref.watch(sessionProgressProvider);
    final filteredQuestions = ref.watch(filteredQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Engagement Checklist'),
        backgroundColor: theme.colorScheme.surface,
        scrolledUnderElevation: 1,
        actions: [
          // Export button
          IconButton(
            onPressed: _exportQuestionnaire,
            icon: const Icon(Icons.download),
            tooltip: 'Export Questionnaire',
          ),
          // Import button
          IconButton(
            onPressed: _importQuestionnaire,
            icon: const Icon(Icons.upload),
            tooltip: 'Import Questionnaire',
          ),
          // Schedule kickoff call button
          FilledButton.icon(
            onPressed: currentProject != null ? _scheduleKickoffCall : null,
            icon: const Icon(Icons.calendar_month),
            label: const Text('Schedule KO Call'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
          AppSpacing.hGapMD,
        ],
      ),
      body: Column(
        children: [
          // Header with progress and stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Column(
              children: [
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                    AppSpacing.hGapMD,
                    Text(
                      '${(progress * 100).round()}%',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                AppSpacing.vGapMD,
                
                // Statistics - Pill Style Summary
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatChip('Total', statistics['total'] ?? 0, Icons.quiz, theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      _buildStatChip('Completed', statistics['completed'] ?? 0, Icons.check_circle, const Color(0xFF10b981)),
                      const SizedBox(width: AppSpacing.sm),
                      _buildStatChip('In Progress', statistics['inProgress'] ?? 0, Icons.access_time, const Color(0xFF3b82f6)),
                      const SizedBox(width: AppSpacing.sm),
                      _buildStatChip('Pending', statistics['pending'] ?? 0, Icons.radio_button_unchecked, const Color(0xFFf59e0b)),
                      const SizedBox(width: AppSpacing.sm),
                      _buildStatChip('Blockers', statistics['blocked'] ?? 0, Icons.block, const Color(0xFFef4444)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search questions...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(questionnaireNotifierProvider.notifier)
                                  .setSearchQuery('');
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    ref.read(questionnaireNotifierProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
                
                AppSpacing.vGapMD,
                
                // Filter buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category filters
                      _buildFilterChip(
                        context,
                        'All Categories',
                        questionnaireState.selectedCategory == null,
                        () => ref.read(questionnaireNotifierProvider.notifier)
                            .setSelectedCategory(null),
                      ),
                      AppSpacing.hGapSM,
                      ...QuestionCategory.values.take(8).map((category) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            context,
                            category.displayName,
                            questionnaireState.selectedCategory == category,
                            () => ref.read(questionnaireNotifierProvider.notifier)
                                .setSelectedCategory(category),
                          ),
                        ),
                      ),
                      
                      Container(
                        width: 1,
                        height: 32,
                        color: theme.colorScheme.outlineVariant,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      
                      // Status filters
                      _buildFilterChip(
                        context,
                        'Completed',
                        questionnaireState.selectedStatus == QuestionStatus.completed,
                        () => ref.read(questionnaireNotifierProvider.notifier)
                            .setSelectedStatus(
                              questionnaireState.selectedStatus == QuestionStatus.completed 
                                  ? null 
                                  : QuestionStatus.completed
                            ),
                      ),
                      AppSpacing.hGapSM,
                      _buildFilterChip(
                        context,
                        'In Progress',
                        questionnaireState.selectedStatus == QuestionStatus.inProgress,
                        () => ref.read(questionnaireNotifierProvider.notifier)
                            .setSelectedStatus(
                              questionnaireState.selectedStatus == QuestionStatus.inProgress 
                                  ? null 
                                  : QuestionStatus.inProgress
                            ),
                      ),
                      AppSpacing.hGapSM,
                      _buildFilterChip(
                        context,
                        'Pending',
                        questionnaireState.selectedStatus == QuestionStatus.pending,
                        () => ref.read(questionnaireNotifierProvider.notifier)
                            .setSelectedStatus(
                              questionnaireState.selectedStatus == QuestionStatus.pending 
                                  ? null 
                                  : QuestionStatus.pending
                            ),
                      ),
                      AppSpacing.hGapSM,
                      _buildFilterChip(
                        context,
                        'Blockers',
                        questionnaireState.selectedStatus == QuestionStatus.blocked,
                        () => ref.read(questionnaireNotifierProvider.notifier)
                            .setSelectedStatus(
                              questionnaireState.selectedStatus == QuestionStatus.blocked 
                                  ? null 
                                  : QuestionStatus.blocked
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Questions list
          Expanded(
            child: questionnaireState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : questionnaireState.error != null
                    ? _buildErrorState(context, questionnaireState.error!)
                    : filteredQuestions.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredQuestions.length,
                            itemBuilder: (context, index) {
                              final question = filteredQuestions[index];
                              final interpolatedQuestion = ref.watch(
                                interpolatedQuestionProvider(question.id)
                              );
                              final answer = questionnaireState.session?.getAnswer(question.id);
                              
                              return QuestionWidgetFactory.create(
                                question: interpolatedQuestion,
                                answer: answer,
                                onAnswerChanged: _onAnswerChanged,
                              );
                            },
                          ),
          ),
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
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            AppSpacing.vGapLG,
            Text(
              'Failed to load questionnaire',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapMD,
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapLG,
            FilledButton(
              onPressed: () {
                ref.read(questionnaireNotifierProvider.notifier).initializeSession();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final questionnaireState = ref.watch(questionnaireNotifierProvider);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.vGapLG,
            Text(
              questionnaireState.selectedCategory != null ||
              questionnaireState.selectedStatus != null ||
              questionnaireState.searchQuery.isNotEmpty
                  ? 'No questions match your filters'
                  : 'No questions available',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapMD,
            Text(
              questionnaireState.selectedCategory != null ||
              questionnaireState.selectedStatus != null ||
              questionnaireState.searchQuery.isNotEmpty
                  ? 'Try clearing your filters to see more questions.'
                  : 'Please select a project to begin the questionnaire.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapLG,
            OutlinedButton(
              onPressed: () {
                ref.read(questionnaireNotifierProvider.notifier).clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _onAnswerChanged(String questionId, dynamic answer, QuestionStatus status) {
    ref.read(questionnaireNotifierProvider.notifier)
        .updateAnswer(questionId, answer, status);
  }

  void _exportQuestionnaire() {
    final data = ref.read(questionnaireNotifierProvider.notifier).exportSession();
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }

  void _importQuestionnaire() {
    // TODO: Implement import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import functionality coming soon')),
    );
  }

  void _scheduleKickoffCall() {
    // TODO: Implement scheduling functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule KO Call functionality coming soon')),
    );
  }
}