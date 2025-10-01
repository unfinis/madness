# Finding Editor Library

A comprehensive Flutter library for creating and editing security findings with rich text support, templates, and export capabilities.

## Overview

The Finding Editor Library provides a complete solution for managing security findings in penetration testing and security assessment applications. It includes:

- **Rich Text Editing**: Full-featured markdown editor with tables, images, and formatting
- **Template System**: Pre-built and custom templates with variable substitution
- **Master-Sub Findings**: Hierarchical relationship support for related findings
- **Export Capabilities**: Export to Markdown, HTML, and JSON
- **Local Storage**: Drift-based database for persistent storage
- **Validation**: Built-in validation for CVSS scores, CWE IDs, and required fields

## Installation

The library is already integrated into your Madness application. All dependencies are in `pubspec.yaml`:

- `flutter_quill` - Rich text editing
- `markdown` - Markdown parsing
- `drift` - Local database
- `freezed` - Immutable models
- `uuid` - ID generation

### Required Setup

**IMPORTANT**: You must add the FlutterQuill localization delegate to your MaterialApp:

```dart
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    FlutterQuillLocalizations.delegate, // Required!
  ],
  supportedLocales: const [
    Locale('en', 'US'),
  ],
  // ... rest of your app
)
```

This has already been added to `lib/widgets/dynamic_title_app.dart` in the Madness application.

## Quick Start

### 1. Import the Library

```dart
import 'package:madness/finding_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### 2. Create a Finding

```dart
final finding = Finding(
  id: const Uuid().v4(),
  title: 'SQL Injection Vulnerability',
  description: '## Description\n\nSQL injection found in login form...',
  severity: FindingSeverity.high,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  cvssScore: '8.6',
  cweId: 'CWE-89',
  status: FindingStatus.draft,
);
```

### 3. Use the Editor Widget

```dart
class FindingEditorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FindingEditorWidget(
      onSave: (finding) {
        // Save finding to repository
        print('Saved finding: ${finding.title}');
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
```

### 4. Edit an Existing Finding

```dart
FindingEditorWidget(
  initialFinding: existingFinding,
  onSave: (updatedFinding) async {
    final repo = ref.read(findingRepositoryProvider);
    await repo.saveFinding(updatedFinding);
  },
)
```

## Using Templates

### Select a Template

```dart
showDialog(
  context: context,
  builder: (context) => TemplatePicker(
    onTemplateSelected: (template) {
      Navigator.of(context).pop();

      // Show editor with template
      showDialog(
        context: context,
        builder: (context) => FindingEditorWidget(
          template: template,
          onSave: (finding) {
            // Save the new finding
          },
        ),
      );
    },
  ),
);
```

### Create Custom Templates

```dart
final template = FindingTemplate(
  id: const Uuid().v4(),
  name: 'My Custom Template',
  category: 'Web Application',
  descriptionTemplate: '''
## Description

The application at {{url}} is vulnerable to {{vulnerability_type}}.

## Impact

{{impact_description}}
''',
  remediationTemplate: '## Remediation\n\n{{remediation_steps}}',
  defaultSeverity: 'medium',
  variables: [
    const TemplateVariable(
      name: 'url',
      label: 'Application URL',
      type: VariableType.url,
      required: true,
    ),
    const TemplateVariable(
      name: 'vulnerability_type',
      label: 'Vulnerability Type',
      type: VariableType.text,
      required: true,
    ),
  ],
  isCustom: true,
  createdAt: DateTime.now(),
);

// Save template
final repo = ref.read(templateRepositoryProvider);
await repo.saveTemplate(template);
```

## Repository Usage

### Finding Repository

```dart
// Get provider
final repo = ref.read(findingRepositoryProvider);

// Get finding by ID
final finding = await repo.getFinding('finding-id');

// Get all findings
final allFindings = await repo.getAllFindings();

// Get master findings (no parent)
final masters = await repo.getMasterFindings();

// Get sub-findings
final subs = await repo.getSubFindings('master-id');

// Save finding
await repo.saveFinding(finding);

// Delete finding
await repo.deleteFinding('finding-id');

// Update markdown field
await repo.updateFindingMarkdown(
  'finding-id',
  'description',
  '# New Description\n\nUpdated content...',
);
```

### Template Repository

```dart
final repo = ref.read(templateRepositoryProvider);

// Get all templates
final templates = await repo.getAllTemplates();

// Get by category
final webTemplates = await repo.getTemplatesByCategory('Web Application');

// Save template
await repo.saveTemplate(template);
```

## Master-Sub Finding Hierarchies

```dart
final hierarchyManager = FindingHierarchyManager(
  ref.read(findingRepositoryProvider),
);

// Add sub-finding to master
await hierarchyManager.addSubFinding('master-id', subFinding);

// Get all sub-findings
final subs = await hierarchyManager.getSubFindings('master-id');

// Get master of a sub-finding
final master = await hierarchyManager.getMasterFinding('sub-id');

// Promote sub-finding to master
await hierarchyManager.promoteSubFinding('sub-id');

// Merge sub-findings into master
final merged = await hierarchyManager.mergeSubFindings(
  'master-id',
  ['sub-id-1', 'sub-id-2'],
);

// Get hierarchy tree
final tree = await hierarchyManager.getHierarchyTree('master-id');
print('Total findings in tree: ${tree.totalFindings}');
```

## Validation

```dart
final validator = FindingValidator();

// Validate finding
final result = validator.validateFinding(finding);

if (!result.isValid) {
  print('Errors: ${result.errors}');
}

if (result.hasWarnings) {
  print('Warnings: ${result.warnings}');
}

// Validate specific fields
bool validCvss = validator.isValidCVSS('7.5'); // true
bool validCwe = validator.isValidCWE('CWE-89'); // true
bool validIp = validator.isValidIPAddress('192.168.1.1'); // true
bool validUrl = validator.isValidURL('https://example.com'); // true

// Check missing required fields
final missing = validator.getMissingRequiredFields(finding, template);
```

## Export

```dart
final exporter = FindingExporter();

// Export to markdown
final markdown = await exporter.exportToMarkdown(finding);

// Export to HTML
final html = await exporter.exportToHtml(finding);

// Export to JSON
final json = await exporter.exportToJson(finding);

// Export multiple findings to report
final findings = await repo.getAllFindings();
final report = await exporter.exportMultipleFindingsToMarkdown(findings);

// Save to file
final file = File('findings_report.md');
await file.writeAsString(report);
```

## Built-in Templates

The library includes pre-built templates:

1. **SQL Injection** - `TemplateManager.createSqlInjectionTemplate()`
2. **Cross-Site Scripting (XSS)** - `TemplateManager.createXssTemplate()`

```dart
final sqlTemplate = TemplateManager.createSqlInjectionTemplate();
final repo = ref.read(templateRepositoryProvider);
await repo.saveTemplate(sqlTemplate);
```

## Markdown Converter

```dart
final converter = MarkdownConverter();

// Convert markdown to Quill Delta
final markdown = '# Title\n\nSome **bold** text';
final delta = converter.markdownToDelta(markdown);

// Convert Delta back to markdown
final backToMarkdown = converter.deltaToMarkdown(delta);

// Parse markdown table
final tableMarkdown = '''
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
''';
final tableData = converter.parseMarkdownTable(tableMarkdown);

// Generate markdown table
final data = [
  ['Name', 'Age'],
  ['Alice', '30'],
  ['Bob', '25'],
];
final generatedTable = converter.generateMarkdownTable(data);
```

## Rich Text Controller

```dart
final controller = RichTextEditorController();

// Load markdown
controller.loadFromMarkdown('# Hello\n\nSome **bold** text');

// Get markdown
final markdown = controller.toMarkdown();

// Insert table
controller.insertTable(3, 3);

// Insert image
controller.insertImage('image-id', 'https://example.com/image.png');

// Insert variable
controller.insertVariable('user_name');

// Formatting
controller.toggleBold();
controller.toggleItalic();
controller.setHeaderLevel(2);
controller.toggleBulletList();
controller.insertLink('https://example.com');

// Check current formatting
if (controller.isBold) {
  print('Selection is bold');
}

// Clean up
controller.dispose();
```

## File Structure

```
lib/
├── finding_editor.dart              # Main export file
└── src/
    ├── models/
    │   ├── finding.dart             # Finding model
    │   ├── finding_template.dart    # Template model
    │   └── finding_field.dart       # Field metadata
    ├── storage/
    │   ├── finding_database.dart    # Drift database
    │   ├── finding_repository.dart  # Finding CRUD
    │   └── template_repository.dart # Template CRUD
    ├── editor/
    │   ├── finding_editor_widget.dart
    │   ├── toolbar/
    │   │   └── editor_toolbar.dart
    │   ├── rich_text/
    │   │   ├── markdown_converter.dart
    │   │   └── rich_text_controller.dart
    │   ├── table/
    │   │   └── table_editor_dialog.dart
    │   ├── image/
    │   │   └── image_picker_widget.dart
    │   └── variables/
    │       └── variable_picker_dialog.dart
    ├── templates/
    │   ├── template_manager.dart
    │   └── template_picker.dart
    ├── master_sub/
    │   └── finding_hierarchy_manager.dart
    ├── utils/
    │   ├── validation.dart
    │   └── export_utils.dart
    └── widgets/
        └── severity_selector.dart
```

## Database Schema

The library uses Drift for local storage with three main tables:

- **Findings** - Stores all finding data with markdown content
- **FindingTemplates** - Stores templates with variables
- **FindingImages** - Stores image attachments as blobs

All data is persisted locally and available offline.

## Best Practices

1. **Always use providers** - Access repositories through Riverpod providers
2. **Validate before saving** - Use `FindingValidator` before persisting
3. **Handle disposal** - Dispose controllers when done
4. **Use templates** - Create reusable templates for common findings
5. **Export regularly** - Export findings to markdown for version control

## Troubleshooting

### Code Generation Issues

If you encounter code generation errors:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Database Issues

Delete the database and rebuild:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Advanced Usage

### Custom Severity Colors

```dart
Color getSeverityColor(FindingSeverity severity) {
  switch (severity) {
    case FindingSeverity.critical:
      return Colors.purple;
    case FindingSeverity.high:
      return Colors.red;
    // ... etc
  }
}
```

### Custom Variable Types

Extend `VariableType` enum for custom variable types and handle them in `VariablePickerDialog`.

### Custom Export Formats

Extend `FindingExporter` to add PDF, DOCX, or other formats.

## License

Part of the Madness Penetration Testing Platform.

## Support

For issues or questions, refer to the main Madness documentation or create an issue in the project repository.
