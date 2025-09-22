import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/outcome_ingestion_service.dart';
import '../providers/methodology_provider.dart';
import '../providers/projects_provider.dart';

class IngestOutcomeDialog extends ConsumerStatefulWidget {
  final String? methodologyId;
  final String? stepId;

  const IngestOutcomeDialog({
    super.key,
    this.methodologyId,
    this.stepId,
  });

  @override
  ConsumerState<IngestOutcomeDialog> createState() => _IngestOutcomeDialogState();
}

class _IngestOutcomeDialogState extends ConsumerState<IngestOutcomeDialog> {
  final _formKey = GlobalKey<FormState>();
  final OutcomeIngestionService _ingestionService = OutcomeIngestionService();

  // Common outcome types
  OutcomeType _selectedType = OutcomeType.custom;

  // Form controllers
  final _rawOutputController = TextEditingController();
  final Map<String, TextEditingController> _fieldControllers = {};

  // Parser type
  String? _selectedParser;

  // Outcome data
  final Map<String, dynamic> _outcomeData = {};

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    // Initialize field controllers based on outcome type
    _fieldControllers['host'] = TextEditingController();
    _fieldControllers['user'] = TextEditingController();
    _fieldControllers['domain'] = TextEditingController();
    _fieldControllers['hash'] = TextEditingController();
    _fieldControllers['password'] = TextEditingController();
    _fieldControllers['service'] = TextEditingController();
    _fieldControllers['port'] = TextEditingController();
    _fieldControllers['details'] = TextEditingController();
  }

  @override
  void dispose() {
    _rawOutputController.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) {
      return const AlertDialog(
        title: Text('No Project Selected'),
        content: Text('Please select a project first.'),
      );
    }

    return AlertDialog(
      title: const Text('Ingest Testing Outcome'),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Outcome Type Selection
                DropdownButtonFormField<OutcomeType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Outcome Type',
                    helperText: 'What type of outcome are you reporting?',
                  ),
                  items: OutcomeType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getOutcomeTypeLabel(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      _clearFields();
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Dynamic fields based on outcome type
                ..._buildFieldsForType(),

                const Divider(height: 32),

                // Raw output section
                Text(
                  'Raw Output (Optional)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),

                // Parser selection
                DropdownButtonFormField<String>(
                  value: _selectedParser,
                  decoration: const InputDecoration(
                    labelText: 'Output Parser',
                    helperText: 'Select if you have raw tool output',
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('None')),
                    DropdownMenuItem(value: 'nmap', child: Text('Nmap')),
                    DropdownMenuItem(value: 'responder', child: Text('Responder')),
                    DropdownMenuItem(value: 'crackmapexec', child: Text('CrackMapExec')),
                    DropdownMenuItem(value: 'hashcat', child: Text('Hashcat')),
                    DropdownMenuItem(value: 'bloodhound', child: Text('BloodHound')),
                    DropdownMenuItem(value: 'enum4linux', child: Text('Enum4Linux')),
                    DropdownMenuItem(value: 'tcpdump', child: Text('TCPDump')),
                    DropdownMenuItem(value: 'arp-scan', child: Text('ARP-Scan')),
                    DropdownMenuItem(value: 'generic', child: Text('Generic')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedParser = value;
                    });
                  },
                ),

                const SizedBox(height: 8),

                // Raw output text field
                TextFormField(
                  controller: _rawOutputController,
                  decoration: const InputDecoration(
                    labelText: 'Paste Raw Output',
                    hintText: 'Paste tool output here for automatic parsing...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 8,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _ingestOutcome,
          child: const Text('Ingest Outcome'),
        ),
      ],
    );
  }

  List<Widget> _buildFieldsForType() {
    switch (_selectedType) {
      case OutcomeType.hashCaptured:
        return [
          TextFormField(
            controller: _fieldControllers['user']!,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'CORP\\jsmith',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['hash']!,
            decoration: const InputDecoration(
              labelText: 'Hash',
              hintText: 'NTLMv2 hash...',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ];

      case OutcomeType.credentialFound:
        return [
          TextFormField(
            controller: _fieldControllers['domain']!,
            decoration: const InputDecoration(
              labelText: 'Domain',
              hintText: 'CORP',
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['user']!,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'jsmith',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['password']!,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Password123!',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ];

      case OutcomeType.adminAccess:
        return [
          TextFormField(
            controller: _fieldControllers['host']!,
            decoration: const InputDecoration(
              labelText: 'Host/IP',
              hintText: '10.10.1.55',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['user']!,
            decoration: const InputDecoration(
              labelText: 'User with Admin',
              hintText: 'CORP\\jsmith',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ];

      case OutcomeType.serviceIdentified:
        return [
          TextFormField(
            controller: _fieldControllers['host']!,
            decoration: const InputDecoration(
              labelText: 'Host/IP',
              hintText: '10.10.1.10',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['service']!,
            decoration: const InputDecoration(
              labelText: 'Service',
              hintText: 'SMB, HTTP, RDP',
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['port']!,
            decoration: const InputDecoration(
              labelText: 'Ports',
              hintText: '445,3389',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ];

      case OutcomeType.domainInfo:
        return [
          TextFormField(
            controller: _fieldControllers['domain']!,
            decoration: const InputDecoration(
              labelText: 'Domain Name',
              hintText: 'CORP.LOCAL',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fieldControllers['details']!,
            decoration: const InputDecoration(
              labelText: 'Domain Controllers (comma-separated)',
              hintText: '10.10.1.20, 10.10.1.21',
            ),
          ),
        ];

      case OutcomeType.custom:
      default:
        return [
          TextFormField(
            controller: _fieldControllers['details']!,
            decoration: const InputDecoration(
              labelText: 'Outcome Details',
              hintText: 'Describe what was discovered...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ];
    }
  }

  String _getOutcomeTypeLabel(OutcomeType type) {
    switch (type) {
      case OutcomeType.hashCaptured:
        return 'Hash Captured';
      case OutcomeType.credentialFound:
        return 'Credential Found';
      case OutcomeType.adminAccess:
        return 'Admin Access Achieved';
      case OutcomeType.vulnerabilityFound:
        return 'Vulnerability Found';
      case OutcomeType.hostDiscovered:
        return 'Host Discovered';
      case OutcomeType.serviceIdentified:
        return 'Service Identified';
      case OutcomeType.domainInfo:
        return 'Domain Information';
      case OutcomeType.custom:
        return 'Custom Outcome';
    }
  }

  void _clearFields() {
    for (final controller in _fieldControllers.values) {
      controller.clear();
    }
    _outcomeData.clear();
  }

  Future<void> _ingestOutcome() async {
    if (!_formKey.currentState!.validate()) return;

    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    // Build outcome data based on type
    _buildOutcomeData();

    try {
      // Ingest the outcome
      final result = await _ingestionService.ingestOutcome(
        projectId: currentProject.id,
        methodologyId: widget.methodologyId ?? 'manual_ingestion',
        stepId: widget.stepId ?? 'manual_step',
        outcome: _outcomeData,
        rawOutput: _rawOutputController.text.isNotEmpty ? _rawOutputController.text : null,
        parserType: _selectedParser,
      );

      if (mounted) {
        Navigator.of(context).pop(result);

        // Show recommendations if any
        if (result.recommendations.isNotEmpty) {
          _showRecommendations(result);
        }

        // Show critical findings if any
        if (result.criticalFindings.isNotEmpty) {
          _showCriticalFindings(result);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ingesting outcome: $e')),
        );
      }
    }
  }

  void _buildOutcomeData() {
    switch (_selectedType) {
      case OutcomeType.hashCaptured:
        _outcomeData['user'] = _fieldControllers['user']!.text;
        _outcomeData['hash'] = _fieldControllers['hash']!.text;
        _outcomeData['hash_type'] = 'NTLMv2';
        break;

      case OutcomeType.credentialFound:
        _outcomeData['domain'] = _fieldControllers['domain']!.text;
        _outcomeData['user'] = _fieldControllers['user']!.text;
        _outcomeData['password'] = _fieldControllers['password']!.text;
        break;

      case OutcomeType.adminAccess:
        _outcomeData['host'] = _fieldControllers['host']!.text;
        _outcomeData['user'] = _fieldControllers['user']!.text;
        break;

      case OutcomeType.serviceIdentified:
        _outcomeData['host'] = _fieldControllers['host']!.text;
        _outcomeData['service'] = _fieldControllers['service']!.text;
        _outcomeData['ports'] = _fieldControllers['port']!.text.split(',').map((p) => p.trim()).toList();
        break;

      case OutcomeType.domainInfo:
        _outcomeData['domain'] = _fieldControllers['domain']!.text;
        final dcs = _fieldControllers['details']!.text.split(',').map((dc) => dc.trim()).toList();
        _outcomeData['dcs'] = dcs;
        break;

      default:
        _outcomeData['details'] = _fieldControllers['details']!.text;
        break;
    }
  }

  void _showRecommendations(IngestionResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recommended Next Steps'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: result.recommendations.take(5).map((rec) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${rec.priority}'),
                ),
                title: Text(rec.methodologyId),
                subtitle: Text(rec.reason),
                trailing: Text('${(rec.confidence * 100).toStringAsFixed(0)}%'),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCriticalFindings(IngestionResult result) {
    showDialog(
      context: context,
      barrierColor: Colors.red.withOpacity(0.2),
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Critical Findings!'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: result.criticalFindings.map((finding) {
              return Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(finding.severity),
                            backgroundColor: _getSeverityColor(finding.severity),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              finding.finding,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(finding.details),
                      const SizedBox(height: 8),
                      Text(
                        'Recommendations:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      ...finding.recommendations.map((rec) => Text('• $rec')),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Acknowledge'),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Colors.red[700]!;
      case 'HIGH':
        return Colors.orange[700]!;
      case 'MEDIUM':
        return Colors.yellow[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}