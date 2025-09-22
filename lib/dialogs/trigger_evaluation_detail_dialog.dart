import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/trigger_evaluation.dart';

class TriggerEvaluationDetailDialog extends StatefulWidget {
  final TriggerMatch match;

  const TriggerEvaluationDetailDialog({
    super.key,
    required this.match,
  });

  @override
  State<TriggerEvaluationDetailDialog> createState() => _TriggerEvaluationDetailDialogState();
}

class _TriggerEvaluationDetailDialogState extends State<TriggerEvaluationDetailDialog> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: match.matched ? Colors.green : Colors.red,
                  child: Icon(
                    match.matched ? Icons.check : Icons.close,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trigger Evaluation Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Trigger ID: ${match.triggerId}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatusTile('Status', match.matched ? 'Matched' : 'No Match'),
                    ),
                    Expanded(
                      child: _buildStatusTile('Confidence', '${(match.confidence * 100).toStringAsFixed(1)}%'),
                    ),
                    Expanded(
                      child: _buildStatusTile('Priority', 'P${match.priority}'),
                    ),
                    Expanded(
                      child: _buildStatusTile('Evaluated', _formatDateTime(match.evaluatedAt)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Extracted Values'),
                Tab(text: 'Debug Info'),
                Tab(text: 'Raw Data'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildExtractedValuesTab(),
                  _buildDebugInfoTab(),
                  _buildRawDataTab(),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Details'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final match = widget.match;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information
          _buildInfoSection('Basic Information', [
            _buildInfoRow('Match ID', match.id),
            _buildInfoRow('Trigger ID', match.triggerId),
            _buildInfoRow('Template ID', match.templateId),
            _buildInfoRow('Asset ID', match.assetId),
            _buildInfoRow('Evaluation Time', match.evaluatedAt.toString()),
          ]),

          const SizedBox(height: 24),

          // Match Results
          _buildInfoSection('Match Results', [
            _buildInfoRow('Matched', match.matched ? 'Yes' : 'No'),
            _buildInfoRow('Confidence Score', '${(match.confidence * 100).toStringAsFixed(2)}%'),
            _buildInfoRow('Priority Level', 'P${match.priority} (${_getPriorityDescription(match.priority)})'),
            if (match.error != null)
              _buildInfoRow('Error', match.error!, isError: true),
          ]),

          const SizedBox(height: 24),

          // Statistics
          _buildInfoSection('Statistics', [
            _buildInfoRow('Extracted Values Count', match.extractedValues.length.toString()),
            _buildInfoRow('Debug Info Entries', match.debugInfo.length.toString()),
            _buildInfoRow('Has Error', match.error != null ? 'Yes' : 'No'),
          ]),
        ],
      ),
    );
  }

  Widget _buildExtractedValuesTab() {
    final match = widget.match;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (match.extractedValues.isEmpty)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No values were extracted during evaluation'),
                ],
              ),
            )
          else
            ...match.extractedValues.entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getValueTypeIcon(entry.value),
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getValueTypeName(entry.value),
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _formatValue(entry.value),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildDebugInfoTab() {
    final match = widget.match;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (match.debugInfo.isEmpty)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bug_report, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No debug information available'),
                ],
              ),
            )
          else
            ...match.debugInfo.entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                leading: Icon(
                  Icons.code,
                  color: Colors.green[600],
                ),
                title: Text(entry.key),
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      _formatValue(entry.value),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildRawDataTab() {
    final match = widget.match;
    final jsonString = const JsonEncoder.withIndent('  ').convert(match.toJson());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.data_object, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Raw JSON Data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _copyJsonToClipboard(context, jsonString),
                icon: const Icon(Icons.copy),
                tooltip: 'Copy JSON',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SelectableText(
              jsonString,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red : null,
                fontWeight: isError ? FontWeight.w500 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getValueTypeIcon(dynamic value) {
    if (value is String) return Icons.text_fields;
    if (value is num) return Icons.numbers;
    if (value is bool) return Icons.toggle_on;
    if (value is List) return Icons.list;
    if (value is Map) return Icons.data_object;
    return Icons.help_outline;
  }

  String _getValueTypeName(dynamic value) {
    if (value is String) return 'String';
    if (value is int) return 'Integer';
    if (value is double) return 'Double';
    if (value is bool) return 'Boolean';
    if (value is List) return 'List';
    if (value is Map) return 'Map';
    return 'Unknown';
  }

  String _formatValue(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is Map || value is List) {
      return const JsonEncoder.withIndent('  ').convert(value);
    } else {
      return value.toString();
    }
  }

  String _getPriorityDescription(int priority) {
    if (priority <= 2) return 'Critical';
    if (priority <= 5) return 'High';
    if (priority <= 7) return 'Medium';
    return 'Low';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.toIso8601String().substring(0, 19).replaceAll('T', ' ')}';
  }

  void _copyToClipboard(BuildContext context) {
    final match = widget.match;
    final text = '''
Trigger Evaluation Details
==========================
Match ID: ${match.id}
Trigger ID: ${match.triggerId}
Template ID: ${match.templateId}
Asset ID: ${match.assetId}
Matched: ${match.matched}
Confidence: ${(match.confidence * 100).toStringAsFixed(2)}%
Priority: P${match.priority}
Evaluated: ${match.evaluatedAt}
${match.error != null ? 'Error: ${match.error!}' : ''}

Extracted Values:
${match.extractedValues.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

Debug Info:
${match.debugInfo.entries.map((e) => '${e.key}: ${e.value}').join('\n')}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details copied to clipboard')),
    );
  }

  void _copyJsonToClipboard(BuildContext context, String jsonString) {
    Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard')),
    );
  }
}