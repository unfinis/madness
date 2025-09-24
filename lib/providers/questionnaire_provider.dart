/// Questionnaire state management with Riverpod
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/questionnaire.dart';
import '../services/questionnaire_service.dart';
import '../services/question_templating_service.dart';
import 'projects_provider.dart';

// Service provider
final questionnaireServiceProvider = Provider<QuestionnaireService>((ref) {
  final templatingService = ref.read(questionTemplatingServiceProvider);
  return QuestionnaireService(templatingService: templatingService);
});

// Configuration provider
final questionnaireConfigProvider = FutureProvider<QuestionnaireConfiguration>((ref) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.loadConfiguration();
});

// Current session provider
final currentQuestionnaireSessionProvider = StateProvider<QuestionnaireSession?>((ref) => null);

// Filtered questions provider
final visibleQuestionsProvider = Provider<List<QuestionDefinition>>((ref) {
  final configAsync = ref.watch(questionnaireConfigProvider);
  final session = ref.watch(currentQuestionnaireSessionProvider);
  final currentProject = ref.watch(currentProjectProvider);
  
  return configAsync.when(
    data: (config) {
      if (session == null) return <QuestionDefinition>[];
      
      final service = ref.read(questionnaireServiceProvider);
      return service.getVisibleQuestions(
        allQuestions: config.questions,
        project: currentProject,
        answers: session.answers,
      );
    },
    loading: () => <QuestionDefinition>[],
    error: (error, stack) => <QuestionDefinition>[],
  );
});

// Filtered questions by category
final questionsByCategoryProvider = Provider.family<List<QuestionDefinition>, QuestionCategory?>((ref, category) {
  final visibleQuestions = ref.watch(visibleQuestionsProvider);
  
  if (category == null) return visibleQuestions;
  
  final service = ref.read(questionnaireServiceProvider);
  return service.getQuestionsByCategory(visibleQuestions, category);
});

// Filtered questions by status
final questionsByStatusProvider = Provider.family<List<QuestionDefinition>, QuestionStatus?>((ref, status) {
  final visibleQuestions = ref.watch(visibleQuestionsProvider);
  final session = ref.watch(currentQuestionnaireSessionProvider);
  
  if (status == null || session == null) return visibleQuestions;
  
  final service = ref.read(questionnaireServiceProvider);
  return service.getQuestionsByStatus(visibleQuestions, status, session.answers);
});

// Session statistics
final sessionStatisticsProvider = Provider<Map<String, int>>((ref) {
  final session = ref.watch(currentQuestionnaireSessionProvider);
  return session?.statistics ?? <String, int>{
    'total': 0,
    'completed': 0,
    'inProgress': 0,
    'pending': 0,
    'blocked': 0,
  };
});

// Session progress percentage
final sessionProgressProvider = Provider<double>((ref) {
  final stats = ref.watch(sessionStatisticsProvider);
  final total = stats['total'] ?? 0;
  final completed = stats['completed'] ?? 0;
  
  if (total == 0) return 0.0;
  return completed / total;
});

// Questionnaire notifier for session management
final questionnaireNotifierProvider = StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>((ref) {
  return QuestionnaireNotifier(ref);
});

class QuestionnaireState {
  final QuestionnaireSession? session;
  final bool isLoading;
  final String? error;
  final QuestionCategory? selectedCategory;
  final QuestionStatus? selectedStatus;
  final String searchQuery;

  const QuestionnaireState({
    this.session,
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.selectedStatus,
    this.searchQuery = '',
  });

  QuestionnaireState copyWith({
    QuestionnaireSession? session,
    bool? isLoading,
    String? error,
    QuestionCategory? selectedCategory,
    QuestionStatus? selectedStatus,
    String? searchQuery,
  }) {
    return QuestionnaireState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final Ref ref;

  QuestionnaireNotifier(this.ref) : super(const QuestionnaireState());

  /// Initialize new session for current project
  Future<void> initializeSession() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) {
      state = state.copyWith(error: 'No project selected');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final configAsync = await ref.read(questionnaireConfigProvider.future);
      final service = ref.read(questionnaireServiceProvider);

      // Get visible questions for current project
      final visibleQuestions = service.getVisibleQuestions(
        allQuestions: configAsync.questions,
        project: currentProject,
        answers: <String, QuestionAnswer>{},
      );

      // Create new session
      final session = service.createSession(
        projectId: currentProject.id,
        questionnaireId: configAsync.metadata.id,
        visibleQuestions: visibleQuestions,
      );

      state = state.copyWith(
        session: session,
        isLoading: false,
      );

      // Update the current session provider
      ref.read(currentQuestionnaireSessionProvider.notifier).state = session;

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update answer for a question
  void updateAnswer(String questionId, dynamic answer, QuestionStatus status) {
    final session = state.session;
    if (session == null) return;

    final updatedAnswer = QuestionAnswer(
      questionId: questionId,
      answer: answer,
      status: status,
      answeredAt: status == QuestionStatus.completed ? DateTime.now() : null,
    );

    final updatedSession = session.updateAnswer(questionId, updatedAnswer);
    
    // Update completion status
    final service = ref.read(questionnaireServiceProvider);
    final finalSession = service.updateSessionCompletion(updatedSession);

    state = state.copyWith(session: finalSession);
    ref.read(currentQuestionnaireSessionProvider.notifier).state = finalSession;
  }

  /// Set category filter
  void setSelectedCategory(QuestionCategory? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Set status filter
  void setSelectedStatus(QuestionStatus? status) {
    state = state.copyWith(selectedStatus: status);
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      selectedCategory: null,
      selectedStatus: null,
      searchQuery: '',
    );
  }

  /// Load existing session
  void loadSession(QuestionnaireSession session) {
    state = state.copyWith(session: session);
    ref.read(currentQuestionnaireSessionProvider.notifier).state = session;
  }

  /// Export session data
  Map<String, dynamic> exportSession() {
    return state.session?.toJson() ?? {};
  }

  /// Import session data
  Future<void> importSession(Map<String, dynamic> data) async {
    try {
      final session = QuestionnaireSession.fromJson(data);
      loadSession(session);
    } catch (e) {
      state = state.copyWith(error: 'Failed to import session: $e');
    }
  }
}

// Filtered questions with search and filters
final filteredQuestionsProvider = Provider<List<QuestionDefinition>>((ref) {
  final notifierState = ref.watch(questionnaireNotifierProvider);
  final visibleQuestions = ref.watch(visibleQuestionsProvider);
  
  var filtered = visibleQuestions;
  
  // Apply category filter
  if (notifierState.selectedCategory != null) {
    final service = ref.read(questionnaireServiceProvider);
    filtered = service.getQuestionsByCategory(filtered, notifierState.selectedCategory!);
  }
  
  // Apply status filter
  if (notifierState.selectedStatus != null && notifierState.session != null) {
    final service = ref.read(questionnaireServiceProvider);
    filtered = service.getQuestionsByStatus(
      filtered, 
      notifierState.selectedStatus!, 
      notifierState.session!.answers,
    );
  }
  
  // Apply search filter
  if (notifierState.searchQuery.isNotEmpty) {
    final query = notifierState.searchQuery.toLowerCase();
    filtered = filtered.where((question) =>
      question.question.toLowerCase().contains(query) ||
      (question.info?.toLowerCase().contains(query) ?? false)
    ).toList();
  }
  
  return filtered;
});

// Question with interpolated text
final interpolatedQuestionProvider = Provider.family<QuestionDefinition, String>((ref, questionId) {
  final visibleQuestions = ref.watch(visibleQuestionsProvider);
  final currentProject = ref.watch(currentProjectProvider);
  final service = ref.read(questionnaireServiceProvider);
  
  final question = visibleQuestions.firstWhere(
    (q) => q.id == questionId,
    orElse: () => throw StateError('Question not found: $questionId'),
  );
  
  if (currentProject == null) return question;
  
  final interpolatedText = service.interpolateQuestionText(question.question, currentProject);
  final interpolatedInfo = question.info != null 
      ? service.interpolateQuestionText(question.info!, currentProject)
      : null;
  
  return QuestionDefinition(
    id: question.id,
    question: interpolatedText,
    info: interpolatedInfo,
    answerType: question.answerType,
    trigger: question.trigger,
    options: question.options,
    displayFields: question.displayFields,
    linkedField: question.linkedField,
    autoPopulate: question.autoPopulate,
    validationRoles: question.validationRoles,
  );
});