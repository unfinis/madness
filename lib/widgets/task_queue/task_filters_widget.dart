import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_queue_provider.dart';

class TaskFiltersWidget extends ConsumerWidget {
  final String projectId;

  const TaskFiltersWidget({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Filters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search tasks...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Future enhancement: Add search functionality
                    },
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<TaskStatus?>(
                  value: null,
                  hint: const Text('Status'),
                  items: [
                    const DropdownMenuItem<TaskStatus?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    ...TaskStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    )),
                  ],
                  onChanged: (value) {
                    // Future enhancement: Add status filtering
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Show Completed'),
                  selected: true,
                  onSelected: (selected) {
                    // Future enhancement: Add completed filter
                  },
                ),
                FilterChip(
                  label: const Text('Show Failed'),
                  selected: true,
                  onSelected: (selected) {
                    // Future enhancement: Add failed filter
                  },
                ),
                FilterChip(
                  label: const Text('High Priority'),
                  selected: false,
                  onSelected: (selected) {
                    // Future enhancement: Add priority filter
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}