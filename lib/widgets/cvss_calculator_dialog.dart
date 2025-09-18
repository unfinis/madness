import 'package:flutter/material.dart';
import 'dart:math' as math;

class CVSSCalculatorDialog extends StatefulWidget {
  final String? initialVector;
  final Function(double score, String vector) onCalculated;

  const CVSSCalculatorDialog({
    super.key,
    this.initialVector,
    required this.onCalculated,
  });

  @override
  State<CVSSCalculatorDialog> createState() => _CVSSCalculatorDialogState();
}

class _CVSSCalculatorDialogState extends State<CVSSCalculatorDialog> {
  late TextEditingController _vectorController;
  
  // CVSS 3.1 metrics
  String _attackVector = 'N';    // Network
  String _attackComplexity = 'L'; // Low
  String _privilegesRequired = 'N'; // None
  String _userInteraction = 'N';  // None
  String _scope = 'U';           // Unchanged
  String _confidentiality = 'N';  // None
  String _integrity = 'N';        // None
  String _availability = 'N';     // None

  double _calculatedScore = 0.0;
  String _calculatedSeverity = 'None';

  @override
  void initState() {
    super.initState();
    _vectorController = TextEditingController(text: widget.initialVector ?? '');
    
    // Parse initial vector if provided
    if (widget.initialVector != null && widget.initialVector!.isNotEmpty) {
      _parseVector(widget.initialVector!);
    }
    
    _calculateScore();
  }

  @override
  void dispose() {
    _vectorController.dispose();
    super.dispose();
  }

  void _parseVector(String vector) {
    final parts = vector.split('/');
    for (final part in parts) {
      if (part.startsWith('AV:')) _attackVector = part.substring(3);
      else if (part.startsWith('AC:')) _attackComplexity = part.substring(3);
      else if (part.startsWith('PR:')) _privilegesRequired = part.substring(3);
      else if (part.startsWith('UI:')) _userInteraction = part.substring(3);
      else if (part.startsWith('S:')) _scope = part.substring(2);
      else if (part.startsWith('C:')) _confidentiality = part.substring(2);
      else if (part.startsWith('I:')) _integrity = part.substring(2);
      else if (part.startsWith('A:')) _availability = part.substring(2);
    }
  }

  String _generateVector() {
    return 'CVSS:3.1/AV:$_attackVector/AC:$_attackComplexity/PR:$_privilegesRequired/UI:$_userInteraction/S:$_scope/C:$_confidentiality/I:$_integrity/A:$_availability';
  }

  void _calculateScore() {
    // CVSS 3.1 calculation
    final avScore = _attackVector == 'N' ? 0.85 : _attackVector == 'A' ? 0.62 : _attackVector == 'L' ? 0.55 : 0.2;
    final acScore = _attackComplexity == 'L' ? 0.77 : 0.44;
    final prScore = _privilegesRequired == 'N' ? 0.85 : (_privilegesRequired == 'L' ? (_scope == 'U' ? 0.62 : 0.68) : (_scope == 'U' ? 0.27 : 0.5));
    final uiScore = _userInteraction == 'N' ? 0.85 : 0.62;
    final cScore = _confidentiality == 'N' ? 0.0 : _confidentiality == 'L' ? 0.22 : 0.56;
    final iScore = _integrity == 'N' ? 0.0 : _integrity == 'L' ? 0.22 : 0.56;
    final aScore = _availability == 'N' ? 0.0 : _availability == 'L' ? 0.22 : 0.56;

    final exploitability = 8.22 * avScore * acScore * prScore * uiScore;
    final impact = 1 - ((1 - cScore) * (1 - iScore) * (1 - aScore));
    
    double baseScore;
    if (impact <= 0) {
      baseScore = 0.0;
    } else {
      if (_scope == 'U') {
        baseScore = math.min((exploitability + impact), 10);
      } else {
        baseScore = math.min((exploitability + (impact * 1.08)) * 1.2, 10);
      }
    }

    // Round to one decimal place
    baseScore = (baseScore * 10).round() / 10;

    setState(() {
      _calculatedScore = baseScore;
      _calculatedSeverity = _getSeverityFromScore(baseScore);
      _vectorController.text = _generateVector();
    });
  }

  String _getSeverityFromScore(double score) {
    if (score == 0.0) return 'None';
    if (score < 4.0) return 'Low';
    if (score < 7.0) return 'Medium';
    if (score < 9.0) return 'High';
    return 'Critical';
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return const Color(0xFFef4444);
      case 'High':
        return const Color(0xFFf59e0b);
      case 'Medium':
        return const Color(0xFFfbbf24);
      case 'Low':
        return const Color(0xFF10b981);
      default:
        return const Color(0xFF6b7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'CVSS 3.1 Calculator',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Vector input
            TextFormField(
              controller: _vectorController,
              decoration: const InputDecoration(
                labelText: 'CVSS Vector',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontFamily: 'monospace'),
              onChanged: (value) {
                _parseVector(value);
                _calculateScore();
              },
            ),
            const SizedBox(height: 24),

            // Metrics
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMetricSection(
                      'Attack Vector',
                      _attackVector,
                      [
                        ('N', 'Network'),
                        ('A', 'Adjacent'),
                        ('L', 'Local'),
                        ('P', 'Physical'),
                      ],
                      (value) {
                        setState(() {
                          _attackVector = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Attack Complexity',
                      _attackComplexity,
                      [
                        ('L', 'Low'),
                        ('H', 'High'),
                      ],
                      (value) {
                        setState(() {
                          _attackComplexity = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Privileges Required',
                      _privilegesRequired,
                      [
                        ('N', 'None'),
                        ('L', 'Low'),
                        ('H', 'High'),
                      ],
                      (value) {
                        setState(() {
                          _privilegesRequired = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'User Interaction',
                      _userInteraction,
                      [
                        ('N', 'None'),
                        ('R', 'Required'),
                      ],
                      (value) {
                        setState(() {
                          _userInteraction = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Scope',
                      _scope,
                      [
                        ('U', 'Unchanged'),
                        ('C', 'Changed'),
                      ],
                      (value) {
                        setState(() {
                          _scope = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Confidentiality',
                      _confidentiality,
                      [
                        ('N', 'None'),
                        ('L', 'Low'),
                        ('H', 'High'),
                      ],
                      (value) {
                        setState(() {
                          _confidentiality = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Integrity',
                      _integrity,
                      [
                        ('N', 'None'),
                        ('L', 'Low'),
                        ('H', 'High'),
                      ],
                      (value) {
                        setState(() {
                          _integrity = value;
                        });
                        _calculateScore();
                      },
                    ),
                    _buildMetricSection(
                      'Availability',
                      _availability,
                      [
                        ('N', 'None'),
                        ('L', 'Low'),
                        ('H', 'High'),
                      ],
                      (value) {
                        setState(() {
                          _availability = value;
                        });
                        _calculateScore();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Results
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVSS Score',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _calculatedScore.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getSeverityColor(_calculatedSeverity),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(_calculatedSeverity),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _calculatedSeverity,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    widget.onCalculated(_calculatedScore, _vectorController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply to Finding'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricSection(
    String title,
    String currentValue,
    List<(String, String)> options,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: options.map((option) {
              final value = option.$1;
              final label = option.$2;
              final isSelected = value == currentValue;
              
              return ChoiceChip(
                label: Text('$label ($value)'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onChanged(value);
                  }
                },
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}