import 'package:flutter/material.dart';
import '../models/finding.dart';

class AddLinkDialog extends StatefulWidget {
  final FindingLink? link;

  const AddLinkDialog({
    super.key,
    this.link,
  });

  @override
  State<AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<AddLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    
    final link = widget.link;
    _titleController = TextEditingController(text: link?.title ?? '');
    _urlController = TextEditingController(text: link?.url ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.link != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Link' : 'Add Link'),
      content: Container(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., OWASP SQL Injection Prevention',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Auto-suggest title from URL
                  if (_titleController.text.isEmpty && _urlController.text.isNotEmpty) {
                    _suggestTitleFromUrl();
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // URL
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://example.com/reference',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL is required';
                  }
                  
                  // Basic URL validation
                  try {
                    final uri = Uri.parse(value);
                    if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
                      return 'Enter a valid URL (starting with http:// or https://)';
                    }
                  } catch (e) {
                    return 'Enter a valid URL';
                  }
                  
                  return null;
                },
                onChanged: (value) {
                  // Auto-suggest title from URL if title is empty
                  if (_titleController.text.isEmpty) {
                    _suggestTitleFromUrl();
                  }
                },
              ),
              const SizedBox(height: 8),
              
              // Quick reference buttons
              Wrap(
                spacing: 8,
                children: [
                  _buildQuickRefButton(
                    'OWASP',
                    'https://owasp.org/',
                    Icons.security,
                  ),
                  _buildQuickRefButton(
                    'NIST',
                    'https://nvd.nist.gov/',
                    Icons.policy,
                  ),
                  _buildQuickRefButton(
                    'CVE',
                    'https://cve.mitre.org/',
                    Icons.bug_report,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveLink,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Widget _buildQuickRefButton(String label, String baseUrl, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        if (_urlController.text.isEmpty) {
          _urlController.text = baseUrl;
          _suggestTitleFromUrl();
        }
      },
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  void _suggestTitleFromUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty && _titleController.text.isEmpty) {
      try {
        final uri = Uri.parse(url);
        String suggestion = '';
        
        // Extract domain for suggestions
        final host = uri.host.toLowerCase();
        if (host.contains('owasp.org')) {
          suggestion = 'OWASP Reference';
        } else if (host.contains('nist.gov')) {
          suggestion = 'NIST Documentation';
        } else if (host.contains('cve.mitre.org')) {
          suggestion = 'CVE Details';
        } else if (host.contains('microsoft.com')) {
          suggestion = 'Microsoft Documentation';
        } else if (host.contains('github.com')) {
          suggestion = 'GitHub Repository';
        } else {
          // Use domain name as fallback
          final domain = host.replaceFirst('www.', '');
          suggestion = '${domain.split('.').first} Reference';
        }
        
        if (suggestion.isNotEmpty) {
          _titleController.text = suggestion;
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }
  }

  void _saveLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final link = FindingLink(
      id: widget.link?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      findingId: widget.link?.findingId ?? '',
      title: _titleController.text.trim(),
      url: _urlController.text.trim(),
      createdDate: widget.link?.createdDate ?? DateTime.now(),
    );

    Navigator.of(context).pop(link);
  }
}