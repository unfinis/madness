/// Finding Editor Library for Flutter
///
/// A comprehensive rich text editor specifically designed for security findings.
/// Supports markdown storage, templates, variables, master-sub relationships,
/// and export to various formats.

// Models
export 'src/models/finding.dart';
export 'src/models/finding_template.dart';
export 'src/models/finding_field.dart';

// Storage
export 'src/storage/finding_database.dart' hide Finding, FindingTemplate;
export 'src/storage/finding_repository.dart';
export 'src/storage/template_repository.dart';

// Editor
export 'src/editor/finding_editor_widget.dart';
export 'src/editor/rich_text/markdown_converter.dart';
export 'src/editor/rich_text/rich_text_controller.dart';
export 'src/editor/toolbar/editor_toolbar.dart';
export 'src/editor/table/table_editor_dialog.dart';
export 'src/editor/image/image_picker_widget.dart';
export 'src/editor/variables/variable_picker_dialog.dart';

// Templates
export 'src/templates/template_manager.dart';
export 'src/templates/template_picker.dart';

// Master-Sub Hierarchy
export 'src/master_sub/finding_hierarchy_manager.dart';

// Utilities
export 'src/utils/validation.dart';
export 'src/utils/export_utils.dart';

// Widgets
export 'src/widgets/severity_selector.dart';
