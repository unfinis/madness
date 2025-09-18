import 'package:flutter/material.dart';
import '../models/finding_template.dart';

class SubFindingSelectionWidget extends StatefulWidget {
  final FindingTemplate template;
  final Set<int> initialSelection;
  final Function(Set<int>) onSelectionChanged;

  const SubFindingSelectionWidget({
    super.key,
    required this.template,
    required this.initialSelection,
    required this.onSelectionChanged,
  });

  @override
  State<SubFindingSelectionWidget> createState() => _SubFindingSelectionWidgetState();
}

class _SubFindingSelectionWidgetState extends State<SubFindingSelectionWidget> {
  late Set<int> _selectedIndices;
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    _selectedIndices = Set.from(widget.initialSelection);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
    widget.onSelectionChanged(_selectedIndices);
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  double _calculateHighestScore() {
    if (_selectedIndices.isEmpty) return 0.0;
    return _selectedIndices
        .map((index) => widget.template.subFindings[index].cvssScore)
        .reduce((a, b) => a > b ? a : b);
  }

  double _calculateAverageScore() {
    if (_selectedIndices.isEmpty) return 0.0;
    final scores = _selectedIndices
        .map((index) => widget.template.subFindings[index].cvssScore)
        .toList();
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  Color _getSeverityColor(double score) {
    if (score >= 9.0) return const Color(0xFFF44336); // Critical - Red
    if (score >= 7.0) return const Color(0xFFFF9800); // High - Orange  
    if (score >= 4.0) return const Color(0xFFFFC107); // Medium - Amber
    return const Color(0xFF4CAF50); // Low - Green
  }

  String _getSeverityLabel(double score) {
    if (score >= 9.0) return 'Critical';
    if (score >= 7.0) return 'High';
    if (score >= 4.0) return 'Medium';
    return 'Low';
  }

  String _getSeverityClass(double score) {
    if (score >= 9.0) return 'score-critical';
    if (score >= 7.0) return 'score-high';
    if (score >= 4.0) return 'score-medium';
    return 'score-low';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with template info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(Icons.description, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.template.title} - ${widget.template.subFindings.length} sub-findings available',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Statistics Header - matches wireframe design
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2FF), // Light blue background like wireframe
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_selectedIndices.length}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'findings selected',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_selectedIndices.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            'Highest Score: ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                          Text(
                            _calculateHighestScore().toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF667EEA),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Avg Score: ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                          Text(
                            _calculateAverageScore().toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF667EEA),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        'Select sub-findings to see statistics',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF999999),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-findings container - matches wireframe styling
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.template.subFindings.length,
              itemBuilder: (context, index) {
                final subFinding = widget.template.subFindings[index];
                final isSelected = _selectedIndices.contains(index);
                final isExpanded = _expandedIndices.contains(index);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF667EEA)
                          : const Color(0xFFE0E0E0),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: isSelected 
                        ? const Color(0xFFF0F2FF)
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      // Header section - matches wireframe exactly
                      InkWell(
                        onTap: () => _toggleSelection(index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggleSelection(index),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  subFinding.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // CVSS Score badge - matches wireframe styling
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getSeverityColor(subFinding.cvssScore),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  subFinding.cvssScore.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getSeverityColor(subFinding.cvssScore) == const Color(0xFFFFC107) 
                                        ? const Color(0xFF333333) // Dark text for yellow background
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Expand toggle - matches wireframe
                              InkWell(
                                onTap: () => _toggleExpansion(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: const Color(0xFF667EEA),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Expandable description section - matches wireframe
                      if (isExpanded) ...[
                        Container(
                          padding: const EdgeInsets.fromLTRB(42, 0, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              if (subFinding.description.isNotEmpty) ...[
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                    children: [
                                      const TextSpan(
                                        text: 'Description: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: subFinding.description.length > 200 
                                            ? '${subFinding.description.substring(0, 200)}...'
                                            : subFinding.description,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (subFinding.checkSteps.isNotEmpty) ...[
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                    children: [
                                      const TextSpan(
                                        text: 'Check Steps: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: subFinding.checkSteps.split('\n')[0],
                                      ),
                                      if (subFinding.checkSteps.contains('\n'))
                                        const TextSpan(text: '...'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (subFinding.recommendation.isNotEmpty) ...[
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                    children: [
                                      const TextSpan(
                                        text: 'Recommendation: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: subFinding.recommendation),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}