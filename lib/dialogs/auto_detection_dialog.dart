import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../services/auto_detection_config.dart';
import '../services/auto_guide_generator.dart';
import '../services/auto_redaction_service.dart';

/// Dialog for configuring and running auto-detection features
class AutoDetectionDialog extends StatefulWidget {
  final ui.Image image;
  final Function(List<AutoGuide>)? onGuidesGenerated;
  final Function(List<RedactionSuggestion>)? onRedactionSuggestionsGenerated;

  const AutoDetectionDialog({
    super.key,
    required this.image,
    this.onGuidesGenerated,
    this.onRedactionSuggestionsGenerated,
  });

  @override
  State<AutoDetectionDialog> createState() => _AutoDetectionDialogState();
}

class _AutoDetectionDialogState extends State<AutoDetectionDialog> {
  AutoDetectionConfig _config = AutoDetectionPresets.pentest;
  String _selectedPreset = 'Pentesting';
  bool _isAnalyzing = false;
  String? _analysisStatus;
  List<AutoGuide> _generatedGuides = [];
  List<RedactionSuggestion> _redactionSuggestions = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.auto_fix_high, size: 28, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'Auto-Detection',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),

            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Configuration Panel
                  Expanded(
                    flex: 2,
                    child: _buildConfigurationPanel(),
                  ),
                  const VerticalDivider(),

                  // Results Panel
                  Expanded(
                    flex: 1,
                    child: _buildResultsPanel(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Action Buttons
            Row(
              children: [
                // Preset Dropdown
                DropdownButton<String>(
                  value: _selectedPreset,
                  items: AutoDetectionPresets.allPresets.keys
                      .map((preset) => DropdownMenuItem(
                            value: preset,
                            child: Text(preset),
                          ))
                      .toList(),
                  onChanged: (preset) {
                    if (preset != null) {
                      setState(() {
                        _selectedPreset = preset;
                        _config = AutoDetectionPresets.allPresets[preset]!;
                      });
                    }
                  },
                ),
                const Spacer(),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),

                // Analyze Button
                ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _runAnalysis,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze'),
                ),
                const SizedBox(width: 12),

                // Apply Button
                ElevatedButton.icon(
                  onPressed: (_generatedGuides.isEmpty && _redactionSuggestions.isEmpty)
                      ? null
                      : _applyResults,
                  icon: const Icon(Icons.check),
                  label: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationPanel() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preset Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preset: $_selectedPreset',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AutoDetectionPresets.getPresetDescription(_selectedPreset),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Feature Toggles
          _buildFeatureToggles(),
          const SizedBox(height: 16),

          // Sensitivity Settings
          _buildSensitivitySettings(),
          const SizedBox(height: 16),

          // Padding Configuration
          _buildPaddingConfiguration(),
          const SizedBox(height: 16),

          // Advanced Options
          _buildAdvancedOptions(),
        ],
      ),
    );
  }

  Widget _buildFeatureToggles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Auto-Generate Guides'),
              subtitle: const Text('Automatically create guides around UI elements and console output'),
              value: _config.enableAutoGuides,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(enableAutoGuides: value);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Auto-Detect Sensitive Data'),
              subtitle: const Text('Identify passwords, hashes, tokens, and other sensitive information'),
              value: _config.enableAutoRedaction,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(enableAutoRedaction: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensitivitySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detection Sensitivity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...DetectionSensitivity.values.map((sensitivity) =>
              RadioListTile<DetectionSensitivity>(
                title: Text(sensitivity.displayName),
                subtitle: Text(sensitivity.description),
                value: sensitivity,
                groupValue: _config.sensitivity,
                onChanged: (value) {
                  setState(() {
                    _config = _config.copyWith(sensitivity: value);
                  });
                },
                secondary: Icon(
                  Icons.circle,
                  color: sensitivity.color,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaddingConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Padding Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: _config.paddingConfig.useUniformPadding,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        paddingConfig: _config.paddingConfig.copyWith(useUniformPadding: value),
                      );
                    });
                  },
                ),
                const Text('Uniform'),
              ],
            ),
            const SizedBox(height: 12),

            if (!_config.paddingConfig.useUniformPadding) ...[
              _buildPaddingSlider('Guide Padding', _config.paddingConfig.guidePadding, (value) {
                setState(() {
                  _config = _config.copyWith(
                    paddingConfig: _config.paddingConfig.copyWith(guidePadding: value),
                  );
                });
              }),
              _buildPaddingSlider('Redaction Padding', _config.paddingConfig.redactionPadding, (value) {
                setState(() {
                  _config = _config.copyWith(
                    paddingConfig: _config.paddingConfig.copyWith(redactionPadding: value),
                  );
                });
              }),
              _buildPaddingSlider('Console Padding', _config.paddingConfig.consolePadding, (value) {
                setState(() {
                  _config = _config.copyWith(
                    paddingConfig: _config.paddingConfig.copyWith(consolePadding: value),
                  );
                });
              }),
            ] else ...[
              _buildPaddingSlider('Uniform Padding', _config.paddingConfig.guidePadding, (value) {
                setState(() {
                  _config = _config.copyWith(
                    paddingConfig: _config.paddingConfig.copyWith(guidePadding: value),
                  );
                });
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaddingSlider(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Row(
          children: [
            Text(label),
            const Spacer(),
            Text('${value}px'),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 20,
          divisions: 20,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Auto-apply High-Priority Redactions'),
              subtitle: const Text('Automatically apply high-priority redaction suggestions'),
              value: _config.autoApplyHighConfidenceRedactions,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(autoApplyHighConfidenceRedactions: value);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Group Similar Detections'),
              subtitle: const Text('Combine nearby guides and redactions to reduce clutter'),
              value: _config.groupSimilarDetections,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(groupSimilarDetections: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Results',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (_analysisStatus != null) ...[
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_analysisStatus!)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guides Results
                if (_generatedGuides.isNotEmpty) ...[
                  Text(
                    'Generated Guides (${_generatedGuides.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._generatedGuides.take(10).map((guide) => Card(
                    child: ListTile(
                      leading: Icon(
                        guide.isVertical ? Icons.line_weight : Icons.linear_scale,
                        color: Colors.blue,
                      ),
                      title: Text(guide.category),
                      subtitle: Text(guide.description),
                      trailing: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  )),
                  if (_generatedGuides.length > 10)
                    Text('... and ${_generatedGuides.length - 10} more'),
                  const SizedBox(height: 16),
                ],

                // Redaction Suggestions
                if (_redactionSuggestions.isNotEmpty) ...[
                  Text(
                    'Redaction Suggestions (${_redactionSuggestions.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._redactionSuggestions.take(10).map((suggestion) => Card(
                    color: suggestion.sensitiveMatch.category == 'Hash' ||
                           suggestion.sensitiveMatch.category == 'Password'
                        ? Colors.red.shade50
                        : Colors.orange.shade50,
                    child: ListTile(
                      leading: Icon(
                        Icons.security,
                        color: suggestion.sensitiveMatch.category == 'Hash' ||
                               suggestion.sensitiveMatch.category == 'Password'
                            ? Colors.red
                            : Colors.orange,
                      ),
                      title: Text(suggestion.sensitiveMatch.category),
                      subtitle: Text(suggestion.sensitiveMatch.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            suggestion.sensitiveMatch.category == 'Hash' ||
                                   suggestion.sensitiveMatch.category == 'Password'
                                ? Icons.warning
                                : Icons.info,
                            color: suggestion.sensitiveMatch.category == 'Hash' ||
                                   suggestion.sensitiveMatch.category == 'Password'
                                ? Colors.red
                                : Colors.orange,
                            size: 20,
                          ),
                          if (suggestion.isAccepted)
                            const Icon(Icons.check, color: Colors.green, size: 16),
                        ],
                      ),
                    ),
                  )),
                  if (_redactionSuggestions.length > 10)
                    Text('... and ${_redactionSuggestions.length - 10} more'),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runAnalysis() async {
    if (mounted) {
      setState(() {
        _isAnalyzing = true;
        _analysisStatus = 'Initializing analysis...';
        _generatedGuides.clear();
        _redactionSuggestions.clear();
      });
    }

    try {
      // Generate guides if enabled
      if (_config.enableAutoGuides) {
        if (mounted) {
          setState(() {
            _analysisStatus = 'Analyzing image for guides...';
          });
        }

        final guides = await AutoGuideGenerator.generateGuides(
          widget.image,
          config: _config.getGuideConfigWithPadding(),
        );

        if (mounted) {
          setState(() {
            _generatedGuides = guides;
            _analysisStatus = 'Found ${guides.length} potential guides.';
          });
        }
      }

      // Detect sensitive data if enabled
      if (_config.enableAutoRedaction) {
        if (mounted) {
          setState(() {
            _analysisStatus = 'Scanning for sensitive data...';
          });
        }

        final redactionResult = await AutoRedactionService.analyzeAndSuggestRedactions(
          widget.image,
          config: _config.getRedactionConfigWithPadding(),
        );

        if (mounted) {
          setState(() {
            _redactionSuggestions = redactionResult.suggestions;
            _analysisStatus = 'Analysis complete! Found ${_generatedGuides.length} guides and ${_redactionSuggestions.length} redaction suggestions.';
          });
        }
      }

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisStatus = 'Analysis failed: $e';
        });
      }
    }
  }

  void _applyResults() {
    if (_generatedGuides.isNotEmpty) {
      widget.onGuidesGenerated?.call(_generatedGuides);
    }

    if (_redactionSuggestions.isNotEmpty) {
      widget.onRedactionSuggestionsGenerated?.call(_redactionSuggestions);
    }

    Navigator.of(context).pop();
  }
}