# Dialog Design System

This directory contains the unified dialog design system for the Madness application. The system provides consistent styling, accessibility features, and enhanced UX across all dialogs.

## Architecture Overview

### Core Components

1. **dialog_system.dart** - Base classes and core dialog infrastructure
2. **dialog_components.dart** - Reusable UI components for forms and content
3. **dialog_utils.dart** - Utilities for accessibility, keyboard shortcuts, and helper dialogs

### Key Features

- ✅ Consistent visual design across all dialogs
- ✅ Built-in accessibility features (focus management, screen reader support)
- ✅ Keyboard shortcuts (ESC to close, Enter to submit)
- ✅ Responsive sizing based on screen size and content
- ✅ Smooth animations with multiple animation types
- ✅ Haptic feedback for mobile devices
- ✅ Type-safe dialog results
- ✅ Standard error handling and loading states

## Usage

### Creating a New Dialog

```dart
class MyDialog extends StandardDialog {
  const MyDialog({super.key})
      : super(
          title: 'My Dialog Title',
          subtitle: 'Optional subtitle',
          icon: Icons.my_icon,
          size: DialogSize.medium,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      DialogComponents.buildTextField(
        context: context,
        label: 'Field Label',
        // ... other properties
      ),
      // ... more content
    ];
  }
}

// Show the dialog
Future<void> showMyDialog(BuildContext context) {
  return showStandardDialog(
    context: context,
    dialog: const MyDialog(),
    animationType: DialogAnimationType.scaleAndFade,
  );
}
```

### Using Dialog Components

#### Text Fields
```dart
DialogComponents.buildTextField(
  context: context,
  label: 'Username',
  controller: _usernameController,
  hintText: 'Enter username',
  prefixIcon: Icons.person,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

#### Dropdown Fields
```dart
DialogComponents.buildDropdownField<MyEnum>(
  context: context,
  label: 'Select Option',
  value: _selectedValue,
  items: MyEnum.values,
  itemBuilder: (item) => Text(item.displayName),
  onChanged: (value) => setState(() => _selectedValue = value!),
)
```

#### Date Fields
```dart
DialogComponents.buildDateField(
  context: context,
  label: 'Due Date',
  selectedDate: _selectedDate,
  onDateSelected: (date) => setState(() => _selectedDate = date),
)
```

#### Form Sections
```dart
DialogComponents.buildFormSection(
  context: context,
  title: 'Section Title',
  icon: Icons.info,
  children: [
    // ... form fields
  ],
)
```

#### Buttons
```dart
// Primary button
DialogComponents.buildPrimaryButton(
  context: context,
  text: 'Submit',
  onPressed: _handleSubmit,
  icon: Icons.check,
  isLoading: _isLoading,
)

// Secondary button
DialogComponents.buildSecondaryButton(
  context: context,
  text: 'Cancel',
  onPressed: () => Navigator.of(context).pop(),
  icon: Icons.close,
)
```

### Dialog Sizes

- `DialogSize.small` (400px) - Simple dialogs with minimal content
- `DialogSize.medium` (600px) - Standard forms and content
- `DialogSize.large` (800px) - Complex forms or detailed content
- `DialogSize.xlarge` (1000px) - Very complex dialogs with multiple sections

### Animation Types

- `DialogAnimationType.scaleAndFade` - Default, elegant scale with fade
- `DialogAnimationType.slideFromBottom` - Mobile-friendly slide up
- `DialogAnimationType.slideFromTop` - Slide down from top
- `DialogAnimationType.fade` - Simple fade in/out

## Accessibility Features

### Built-in Accessibility
- Proper focus management and tab order
- Screen reader announcements for important actions
- Semantic labels for all form fields
- Keyboard shortcuts (ESC, Enter, Tab)
- High contrast support
- Focus trapping within dialogs

### Using Accessibility Utils
```dart
// Add keyboard shortcuts
DialogUtils.withKeyboardShortcuts(
  onEscape: () => Navigator.of(context).pop(),
  onEnter: _handleSubmit,
  child: myDialogContent,
)

// Announce to screen readers
DialogUtils.announceToScreenReader(
  context,
  'Form submitted successfully',
  assertiveness: Assertiveness.polite,
)

// Trigger haptic feedback
DialogUtils.triggerHapticFeedback(HapticFeedbackType.light);
```

### Standard Helper Dialogs

```dart
// Confirmation dialog
final confirmed = await DialogUtils.showConfirmationDialog(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  isDestructive: true,
);

// Error dialog
await DialogUtils.showErrorDialog(
  context: context,
  title: 'Operation Failed',
  message: 'Unable to save changes',
  details: error.toString(),
  onRetry: _retryOperation,
);

// Loading dialog
await DialogUtils.showLoadingDialog(
  context: context,
  message: 'Saving changes...',
  canCancel: true,
);
```

## Migration Guide

### From Old Dialog Style

**Before:**
```dart
class OldDialog extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Title'),
      content: Column(
        children: [
          TextField(/* ... */),
          // ... more fields
        ],
      ),
      actions: [
        TextButton(/* ... */),
        ElevatedButton(/* ... */),
      ],
    );
  }
}
```

**After:**
```dart
class NewDialog extends StandardDialog {
  const NewDialog({super.key})
      : super(
          title: 'Title',
          icon: Icons.my_icon,
          size: DialogSize.medium,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      const _DialogContent(),
    ];
  }
}

class _DialogContent extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogComponents.buildTextField(/* ... */),
        // ... more components
        Row(
          children: [
            Expanded(
              child: DialogComponents.buildSecondaryButton(/* ... */),
            ),
            AppSpacing.hGapLG,
            Expanded(
              child: DialogComponents.buildPrimaryButton(/* ... */),
            ),
          ],
        ),
      ],
    );
  }
}
```

## Design System Constants

### Spacing
- Use `AppSpacing` constants for consistent spacing
- `AppSpacing.vGapSM`, `AppSpacing.vGapMD`, etc. for vertical gaps
- `AppSpacing.hGapSM`, `AppSpacing.hGapMD`, etc. for horizontal gaps

### Border Radius
- Dialog containers: `DialogConstants.borderRadius` (16px)
- Form fields: `DialogConstants.fieldBorderRadius` (12px)
- Buttons: `DialogConstants.buttonBorderRadius` (12px)

### Colors
- Use theme colors: `Theme.of(context).colorScheme.primary`
- For status colors, use `DialogComponents` helper methods

## Performance Considerations

- Use `const` constructors where possible
- Implement proper `dispose()` methods for controllers
- Avoid rebuilding entire dialog content on state changes
- Use `StatefulWidget` only for content that actually needs state

## Testing

When testing dialogs:

```dart
testWidgets('dialog shows and can be dismissed', (tester) async {
  await tester.pumpWidget(MyApp());

  // Show dialog
  await showStandardDialog(
    context: tester.element(find.byType(MyApp)),
    dialog: const MyDialog(),
  );
  await tester.pumpAndSettle();

  // Verify dialog is shown
  expect(find.text('My Dialog Title'), findsOneWidget);

  // Test ESC key dismissal
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();

  // Verify dialog is dismissed
  expect(find.text('My Dialog Title'), findsNothing);
});
```

## Best Practices

1. **Always use the StandardDialog base class** for consistency
2. **Use DialogComponents** for all form elements
3. **Implement proper validation** for all required fields
4. **Add loading states** for async operations
5. **Use semantic labels** for accessibility
6. **Test keyboard navigation** and screen reader compatibility
7. **Handle errors gracefully** with proper user feedback
8. **Use appropriate dialog sizes** based on content
9. **Implement proper focus management**
10. **Add haptic feedback** for better mobile UX

## Examples

See the following files for complete examples:
- `evidence_dialog_new.dart` - Simple dialog with file operations
- `export_dialog_new.dart` - Basic form dialog with validation
- `add_credential_dialog_new.dart` - Complex form with multiple sections
- `add_task_dialog_new.dart` - Advanced form with dynamic content
- `new_project_dialog_new.dart` - Large dialog with multiple sections and validation

## Support

For questions or issues with the dialog system:
1. Check this documentation first
2. Look at existing dialog examples
3. Review the component library for available widgets
4. Test accessibility features with screen readers
5. Validate responsive behavior on different screen sizes