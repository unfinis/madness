# Finding Editor - Troubleshooting Guide

## Common Issues and Solutions

### 1. FlutterQuillLocalizations Error

**Error:**
```
MissingFlutterQuillLocalizationException: FlutterQuillLocalizations instance is required
```

**Solution:**
Add the FlutterQuill localization delegate to your MaterialApp:

```dart
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    FlutterQuillLocalizations.delegate, // Add this!
  ],
  supportedLocales: const [
    Locale('en', 'US'),
  ],
  // ...
)
```

**Status:** ✅ Fixed in `lib/widgets/dynamic_title_app.dart`

---

### 2. Code Generation Errors

**Error:**
```
Target of URI hasn't been generated: 'package:madness/src/models/finding.g.dart'
```

**Solution:**
Run the code generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Common causes:**
- Missing `part` statements in model files
- Freezed/json_serializable annotations not properly configured
- Build runner cache issues

---

### 3. Import Conflicts

**Error:**
```
The name 'Finding' is defined in multiple libraries
```

**Solution:**
The library export file hides conflicting types:

```dart
// lib/finding_editor.dart
export 'src/storage/finding_database.dart' hide Finding, FindingTemplate;
```

This ensures only the models from `src/models/` are exported.

---

### 4. Database Errors

**Error:**
```
DatabaseException: no such table: findings
```

**Solution:**
The database schema needs to be initialized. Try:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

If the issue persists, delete the app data and reinstall.

---

### 5. Provider Not Found

**Error:**
```
ProviderNotFoundException: No provider found for findingRepositoryProvider
```

**Solution:**
Ensure your app is wrapped in `ProviderScope`:

```dart
void main() {
  runApp(
    const ProviderScope(  // Required!
      child: MyApp(),
    ),
  );
}
```

---

### 6. Markdown Conversion Issues

**Issue:** Markdown not rendering correctly or Delta conversion failing

**Solution:**
The markdown converter supports:
- Headers (h1-h6)
- Bold, italic, underline
- Lists (bullet and numbered)
- Links
- Images
- Code blocks
- Blockquotes
- Tables (via table editor)

If certain markdown features aren't working, they may need custom handling in `MarkdownConverter`.

---

### 7. Image Insertion Failing

**Issue:** Images not showing after insertion

**Causes:**
- Image data not properly base64 encoded
- Image too large
- Invalid image format

**Solution:**
The ImagePickerWidget automatically handles:
```dart
final base64Image = base64Encode(_imageData!);
final imageUrl = 'data:image/jpeg;base64,$base64Image';
```

Ensure images are reasonable size (<5MB recommended).

---

### 8. Template Variables Not Replacing

**Issue:** {{variables}} showing in output instead of values

**Solution:**
Variables are only replaced when explicitly resolved:

```dart
final manager = TemplateManager(repository);
final resolved = manager.resolveVariables(
  template.descriptionTemplate,
  {'variable_name': 'value'},
);
```

The editor automatically handles this during save.

---

### 9. Performance Issues with Large Documents

**Issue:** Editor slow with very long content

**Solutions:**
- Break large findings into master-sub relationships
- Use pagination for finding lists
- Consider limiting description length
- Disable real-time markdown preview for large docs

---

### 10. Validation Errors

**Issue:** CVSS or CWE validation failing

**Valid formats:**
```dart
// CVSS - Simple score
'7.5'
'9.8'

// CVSS - Vector string
'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H'

// CWE
'CWE-79'
'CWE-89'
'cwe-22' // Case insensitive
```

---

## Debug Checklist

When encountering issues, check:

- ✅ FlutterQuillLocalizations delegate added to MaterialApp
- ✅ ProviderScope wraps your app
- ✅ Code generation completed successfully
- ✅ All imports are correct
- ✅ Dependencies in pubspec.yaml
- ✅ Database initialized properly
- ✅ No conflicting type exports

---

## Getting Help

1. Check the main README: `FINDING_EDITOR_README.md`
2. Review example code: `example/finding_editor_example.dart`
3. Check implementation summary: `FINDING_EDITOR_IMPLEMENTATION_SUMMARY.md`
4. Enable verbose logging in Drift:

```dart
final db = FindingDatabase();
db.customStatement('PRAGMA journal_mode=WAL');
```

---

## Known Limitations

1. **PDF Export**: Not yet implemented (export to markdown then convert externally)
2. **Real-time Collaboration**: Single-user only
3. **Image Storage**: Stored as blobs in database (consider external storage for production)
4. **Undo/Redo**: Limited by flutter_quill's built-in support
5. **Code Block Syntax Highlighting**: Basic support only

---

## Performance Tips

1. **Use indexes**: Add database indexes for frequently queried fields
2. **Batch operations**: Use transactions for multiple saves
3. **Lazy loading**: Load findings on demand, not all at once
4. **Image optimization**: Compress images before insertion
5. **Pagination**: Implement pagination for large finding lists

---

## Security Considerations

1. **Input sanitization**: The editor stores markdown - sanitize on export
2. **Image validation**: Validate image content before storage
3. **CVSS/CWE validation**: Use built-in validators
4. **Database encryption**: Consider encrypting the Drift database
5. **Export sanitization**: Sanitize HTML/JSON exports

---

## Upgrade Path

When updating flutter_quill or other dependencies:

1. Check breaking changes in changelogs
2. Update localization delegates if needed
3. Re-run code generation
4. Test all editor features
5. Verify export formats still work

---

## Common Questions

**Q: Can I use a different rich text editor?**
A: Yes, but you'd need to reimplement the markdown conversion and toolbar.

**Q: How do I add custom toolbar buttons?**
A: Extend `EditorToolbar` and add your custom buttons.

**Q: Can I customize the database schema?**
A: Yes, modify `finding_database.dart` and re-run the generator.

**Q: How do I backup findings?**
A: Export to JSON and store externally, or copy the Drift database file.

**Q: Can findings be synchronized across devices?**
A: Not built-in. Consider implementing cloud sync on top of the repository layer.

---

## Report Issues

If you encounter issues not covered here:

1. Check if it's a flutter_quill issue: https://github.com/singerdmx/flutter-quill
2. Check if it's a Drift issue: https://drift.simonbinder.eu/
3. Document the error with stack trace
4. Provide minimal reproduction steps
