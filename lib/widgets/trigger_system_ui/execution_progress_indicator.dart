import 'package:flutter/material.dart';

/// Progress information for an ongoing execution
class ExecutionProgress {
  final String currentStep;
  final int completed;
  final int total;
  final bool hasError;
  final String? errorMessage;

  ExecutionProgress({
    required this.currentStep,
    required this.completed,
    required this.total,
    this.hasError = false,
    this.errorMessage,
  });

  double get percentage => total > 0 ? completed / total : 0.0;
}

/// Widget showing real-time execution progress
class ExecutionProgressIndicator extends StatelessWidget {
  final Stream<ExecutionProgress> progressStream;

  const ExecutionProgressIndicator({
    super.key,
    required this.progressStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ExecutionProgress>(
      stream: progressStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final progress = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress.percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.hasError ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    progress.currentStep,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${progress.completed}/${progress.total}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (progress.hasError && progress.errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        progress.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Circular progress indicator with percentage
class CircularExecutionProgress extends StatelessWidget {
  final ExecutionProgress progress;
  final double size;

  const CircularExecutionProgress({
    super.key,
    required this.progress,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress.hasError ? Colors.red : Colors.blue,
            ),
          ),
          Text(
            '${(progress.percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
