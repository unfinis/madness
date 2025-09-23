import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_spacing.dart';
import 'dialog_system.dart';

/// Reusable dialog components for consistent UI
class DialogComponents {
  DialogComponents._();

  // ================== FORM FIELDS ==================

  /// Standard text field with consistent styling
  static Widget buildTextField({
    required BuildContext context,
    required String label,
    TextEditingController? controller,
    String? hintText,
    String? helperText,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixPressed,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool readOnly = false,
    int maxLines = 1,
    int? minLines,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        AppSpacing.vGapSM,
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: Theme.of(context).colorScheme.primary,
                    size: AppSizes.iconMD,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixPressed,
                    icon: Icon(suffixIcon, size: AppSizes.iconMD),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  /// Standard dropdown field with consistent styling
  static Widget buildDropdownField<T>({
    required BuildContext context,
    required String label,
    required T? value,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required void Function(T?) onChanged,
    String? hintText,
    IconData? prefixIcon,
    bool isEnabled = true,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        AppSpacing.vGapSM,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: Theme.of(context).colorScheme.primary,
                      size: AppSizes.iconMD,
                    )
                  : null,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: itemBuilder(item),
              );
            }).toList(),
            onChanged: isEnabled ? onChanged : null,
            validator: validator,
            dropdownColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }

  /// Standard date picker field
  static Widget buildDateField({
    required BuildContext context,
    required String label,
    DateTime? selectedDate,
    required void Function(DateTime?) onDateSelected,
    DateTime? firstDate,
    DateTime? lastDate,
    bool isEnabled = true,
    String? Function(DateTime?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        AppSpacing.vGapSM,
        InkWell(
          onTap: isEnabled
              ? () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(1900),
                    lastDate: lastDate ?? DateTime(2100),
                  );
                  if (picked != null) {
                    onDateSelected(picked);
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
              color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: AppSizes.iconMD,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Select a date',
                    style: selectedDate != null
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: AppSizes.iconLG,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Standard tri-state dropdown (enabled/disabled/unknown)
  static Widget buildTriStateDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required void Function(String?) onChanged,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.vGapXS,
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          AppSpacing.vGapSM,
        ],
        buildDropdownField<String?>(
          context: context,
          label: subtitle == null ? label : '',
          value: value.isEmpty ? null : value,
          items: const [null, 'enabled', 'disabled'],
          itemBuilder: (String? item) {
            if (item == null) return const Text('Unknown');
            if (item == 'enabled') return const Text('Enabled');
            return const Text('Disabled');
          },
          onChanged: (value) => isEnabled ? onChanged(value) : null,
          isEnabled: isEnabled,
        ),
      ],
    );
  }

  // ================== SECTIONS & LAYOUT ==================

  /// Standard form section with title and content
  static Widget buildFormSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    IconData? icon,
    bool collapsible = false,
    bool initiallyExpanded = true,
  }) {
    if (collapsible) {
      return Card(
        elevation: 2,
        child: ExpansionTile(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconMD, color: Colors.grey[700]),
                AppSpacing.hGapSM,
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          initiallyExpanded: initiallyExpanded,
          children: [
            Padding(
              padding: AppSpacing.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSizes.iconMD, color: Colors.grey[700]),
                  AppSpacing.hGapSM,
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AppSpacing.vGapLG,
            ...children,
          ],
        ),
      ),
    );
  }

  /// Standard info card with icon and content
  static Widget buildInfoCard({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: AppSizes.iconMD,
                    color: textColor ?? Colors.grey[700],
                  ),
                  AppSpacing.hGapSM,
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            AppSpacing.vGapSM,
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Code block with copy functionality
  static Widget buildCodeBlock({
    required BuildContext context,
    required String code,
    String? language,
    bool showCopyButton = true,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.contentPadding,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language != null || showCopyButton) ...[
            Row(
              children: [
                if (language != null)
                  Text(
                    language.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                const Spacer(),
                if (showCopyButton)
                  IconButton(
                    icon: const Icon(Icons.copy, size: AppSizes.iconSM),
                    onPressed: () => _copyToClipboard(context, code),
                    tooltip: 'Copy to clipboard',
                  ),
              ],
            ),
            const Divider(),
          ],
          SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================== BUTTONS ==================

  /// Standard primary button
  static Widget buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    String? loadingText,
  }) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
        ),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSizes.iconSM,
                  height: AppSizes.iconSM,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                AppSpacing.hGapSM,
                Text(loadingText ?? 'Loading...'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSizes.iconSM),
                  AppSpacing.hGapSM,
                ],
                Text(text),
              ],
            ),
    );
  }

  /// Standard secondary button
  static Widget buildSecondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconSM),
            AppSpacing.hGapSM,
          ],
          Text(text),
        ],
      ),
    );
  }

  // ================== STATUS & BADGES ==================

  /// Status chip with color coding
  static Widget buildStatusChip({
    required BuildContext context,
    required String status,
    Color? color,
    IconData? icon,
  }) {
    final chipColor = color ?? _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 3),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? _getStatusIcon(status),
            size: AppSizes.iconXS,
            color: chipColor,
          ),
          AppSpacing.hGapXS,
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state widget
  static Widget buildEmptyState({
    required BuildContext context,
    required String message,
    IconData? icon,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.info_outline,
            size: AppSizes.huge,
            color: Colors.grey[400],
          ),
          AppSpacing.vGapLG,
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            AppSpacing.vGapLG,
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }

  // ================== HELPER METHODS ==================

  static void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.green;
      case 'in_progress':
      case 'running':
        return Colors.blue;
      case 'pending':
      case 'waiting':
        return Colors.orange;
      case 'failed':
      case 'error':
        return Colors.red;
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  static IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Icons.check_circle;
      case 'in_progress':
      case 'running':
        return Icons.play_circle;
      case 'pending':
      case 'waiting':
        return Icons.schedule;
      case 'failed':
      case 'error':
        return Icons.error;
      case 'skipped':
        return Icons.skip_next;
      default:
        return Icons.help;
    }
  }

  // ================== MISSING METHODS ==================

  /// Switch field with consistent styling
  static Widget buildSwitchField({
    required BuildContext context,
    required String label,
    String? subtitle,
    required bool value,
    required void Function(bool) onChanged,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    AppSpacing.vGapXS,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  /// Action buttons row with consistent styling
  static Widget buildActionButtons({
    required BuildContext context,
    required ActionButton primaryAction,
    ActionButton? secondaryAction,
  }) {
    return Padding(
      padding: AppSpacing.contentPadding,
      child: Row(
        children: [
          if (secondaryAction != null) ...[
            Expanded(
              child: _buildActionButton(context, secondaryAction),
            ),
            AppSpacing.hGapLG,
          ],
          Expanded(
            child: _buildActionButton(context, primaryAction),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButton(BuildContext context, ActionButton action) {
    switch (action.type) {
      case ActionButtonType.primary:
        return FilledButton(
          onPressed: action.onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
            ),
          ),
          child: action.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    AppSpacing.hGapSM,
                    Text(action.loadingText ?? 'Loading...'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (action.icon != null) ...[
                      Icon(action.icon!, size: AppSizes.iconSM),
                      AppSpacing.hGapSM,
                    ],
                    Text(action.label),
                  ],
                ),
        );
      case ActionButtonType.secondary:
        return OutlinedButton(
          onPressed: action.onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (action.icon != null) ...[
                Icon(action.icon!, size: AppSizes.iconSM),
                AppSpacing.hGapSM,
              ],
              Text(action.label),
            ],
          ),
        );
      case ActionButtonType.text:
        return TextButton(
          onPressed: action.onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (action.icon != null) ...[
                Icon(action.icon!, size: AppSizes.iconSM),
                AppSpacing.hGapSM,
              ],
              Text(action.label),
            ],
          ),
        );
    }
  }
}

// ================== DATA CLASSES ==================

/// Action button configuration
class ActionButton {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ActionButtonType type;
  final bool isLoading;
  final String? loadingText;

  const ActionButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.type = ActionButtonType.primary,
    this.isLoading = false,
    this.loadingText,
  });
}

/// Action button types
enum ActionButtonType {
  primary,
  secondary,
  text,
}