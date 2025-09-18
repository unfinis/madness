import 'package:flutter_test/flutter_test.dart';
import 'package:madness/database/database.dart';
import 'package:madness/models/task.dart';
import 'package:madness/models/project.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MadnessDatabase database;
  const uuid = Uuid();
  final testProjectId = uuid.v4();
  
  setUpAll(() async {
    database = MadnessDatabase();
    
    // Create a test project first
    final testProject = Project(
      id: testProjectId,
      name: 'Test Project',
      reference: 'TEST-2025-001',
      clientName: 'Test Client',
      projectType: 'Test Type',
      status: ProjectStatus.active,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      constraints: 'None',
      rules: [],
      scope: 'Test scope',
      assessmentScope: {},
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
    
    await database.insertProject(testProject);
  });
  
  tearDownAll(() async {
    // Clean up test data
    await database.deleteProject(testProjectId);
    await database.close();
  });
  
  group('Task Database Operations', () {
    test('Insert and retrieve task', () async {
      // Create a test task
      final taskId = uuid.v4();
      final testTask = Task(
        id: taskId,
        title: 'Test Task',
        description: 'This is a test task',
        category: TaskCategory.admin,
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
        assignedTo: 'Test User',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        progress: 0,
        createdDate: DateTime.now(),
      );
      
      // Insert the task
      await database.insertTask(testTask, testProjectId);
      
      // Retrieve the task
      final retrievedTask = await database.getTask(taskId);
      
      // Verify the task was stored and retrieved correctly
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, equals(taskId));
      expect(retrievedTask.title, equals('Test Task'));
      expect(retrievedTask.description, equals('This is a test task'));
      expect(retrievedTask.category, equals(TaskCategory.admin));
      expect(retrievedTask.status, equals(TaskStatus.pending));
      expect(retrievedTask.priority, equals(TaskPriority.medium));
      expect(retrievedTask.assignedTo, equals('Test User'));
      expect(retrievedTask.progress, equals(0));
      
      // Clean up
      await database.deleteTask(taskId);
    });
    
    test('Update task', () async {
      // Create and insert a task
      final taskId = uuid.v4();
      final testTask = Task(
        id: taskId,
        title: 'Original Title',
        category: TaskCategory.admin,
        status: TaskStatus.pending,
        priority: TaskPriority.low,
        progress: 0,
        createdDate: DateTime.now(),
      );
      
      await database.insertTask(testTask, testProjectId);
      
      // Update the task
      final updatedTask = testTask.copyWith(
        title: 'Updated Title',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        progress: 50,
      );
      
      await database.updateTask(updatedTask, testProjectId);
      
      // Retrieve and verify the update
      final retrievedTask = await database.getTask(taskId);
      
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.title, equals('Updated Title'));
      expect(retrievedTask.status, equals(TaskStatus.inProgress));
      expect(retrievedTask.priority, equals(TaskPriority.high));
      expect(retrievedTask.progress, equals(50));
      
      // Clean up
      await database.deleteTask(taskId);
    });
    
    test('Get all tasks for project', () async {
      // Insert multiple tasks
      final taskIds = <String>[];
      for (int i = 0; i < 3; i++) {
        final taskId = uuid.v4();
        taskIds.add(taskId);
        
        final task = Task(
          id: taskId,
          title: 'Task $i',
          category: TaskCategory.values[i % TaskCategory.values.length],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          progress: i * 25,
          createdDate: DateTime.now(),
        );
        
        await database.insertTask(task, testProjectId);
      }
      
      // Retrieve all tasks
      final tasks = await database.getAllTasks(testProjectId);
      
      // Verify we got all tasks
      expect(tasks.length, greaterThanOrEqualTo(3));
      
      // Verify our tasks are in the results
      for (final taskId in taskIds) {
        expect(tasks.any((t) => t.id == taskId), isTrue);
      }
      
      // Clean up
      for (final taskId in taskIds) {
        await database.deleteTask(taskId);
      }
    });
    
    test('Delete task', () async {
      // Create and insert a task
      final taskId = uuid.v4();
      final testTask = Task(
        id: taskId,
        title: 'Task to Delete',
        category: TaskCategory.admin,
        status: TaskStatus.pending,
        priority: TaskPriority.low,
        progress: 0,
        createdDate: DateTime.now(),
      );
      
      await database.insertTask(testTask, testProjectId);
      
      // Verify it exists
      var retrievedTask = await database.getTask(taskId);
      expect(retrievedTask, isNotNull);
      
      // Delete the task
      await database.deleteTask(taskId);
      
      // Verify it's deleted
      retrievedTask = await database.getTask(taskId);
      expect(retrievedTask, isNull);
    });
  });
}