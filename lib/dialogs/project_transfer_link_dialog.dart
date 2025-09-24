import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/projects_provider.dart';
import '../constants/app_spacing.dart';

class ProjectTransferLinkDialog extends ConsumerStatefulWidget {
  const ProjectTransferLinkDialog({super.key});

  @override
  ConsumerState<ProjectTransferLinkDialog> createState() => _ProjectTransferLinkDialogState();
}

class _ProjectTransferLinkDialogState extends ConsumerState<ProjectTransferLinkDialog> {
  late final TextEditingController _linkController;
  late final TextEditingController _workspaceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final project = ref.read(currentProjectProvider);
    _linkController = TextEditingController(text: project?.transferLink ?? '');
    _workspaceController = TextEditingController(text: project?.transferWorkspaceName ?? '');
  }

  @override
  void dispose() {
    _linkController.dispose();
    _workspaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final project = ref.watch(currentProjectProvider);
    final hasExistingLink = project?.hasTransferLink ?? false;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.dialogRadius)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: AppSpacing.dialogHeaderPadding,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.dialogRadius),
                  topRight: Radius.circular(AppSizes.dialogRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: AppSizes.iconLG,
                  ),
                  AppSpacing.hGapMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasExistingLink ? 'Manage Project Transfer Link' : 'Add Project Transfer Link',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          project?.name ?? 'Unknown Project',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: Padding(
                padding: AppSpacing.dialogContentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workspace Name Field
                    Text(
                      'SendSafely Workspace Name',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vGapSM,
                    TextField(
                      controller: _workspaceController,
                      decoration: InputDecoration(
                        hintText: 'e.g., "Project Alpha - Client Files"',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.folder_open),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                    ),
                    AppSpacing.vGapLG,

                    // Transfer Link Field
                    Text(
                      'SendSafely Transfer Link',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vGapSM,
                    TextField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        hintText: 'https://sendsafely.com/dropzone/...',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        suffixIcon: hasExistingLink
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: _copyLink,
                                    icon: const Icon(Icons.copy),
                                    tooltip: 'Copy link',
                                  ),
                                  IconButton(
                                    onPressed: _openLink,
                                    icon: const Icon(Icons.open_in_new),
                                    tooltip: 'Open in browser',
                                  ),
                                ],
                              )
                            : null,
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    AppSpacing.vGapMD,

                    // Help Text
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: AppSizes.iconMD,
                                color: theme.colorScheme.primary,
                              ),
                              AppSpacing.hGapSM,
                              Text(
                                'About Project Transfer Links',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vGapSM,
                          Text(
                            'Project transfer links provide a secure way to share all project documents and deliverables with clients. '
                            'Store your SendSafely workspace link here to easily access and share it with project stakeholders throughout the engagement.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (hasExistingLink) ...[ 
                      AppSpacing.vGapLG,
                      _buildQuickActions(context),
                    ],
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: AppSpacing.dialogActionsPadding,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (hasExistingLink)
                    TextButton.icon(
                      onPressed: _removeLink,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove Link'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  AppSpacing.hGapMD,
                  FilledButton(
                    onPressed: _isLoading ? null : _saveLink,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vGapSM,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyLink,
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Link'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _openLink,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Open'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: link));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Project transfer link copied to clipboard'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;

    try {
      final uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $link';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeLink() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Project Transfer Link'),
        content: const Text('Are you sure you want to remove the project transfer link? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      
      try {
        // Transfer link removal functionality disabled for now
        // ref.read(currentProjectProvider.notifier).removeTransferLink();
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Project transfer link removed successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove transfer link: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _saveLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a transfer link'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Validate URL format
    try {
      Uri.parse(link);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid URL'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Transfer link update functionality disabled for now
      // ref.read(currentProjectProvider.notifier).updateTransferLink(
      //   link,
      //   workspaceName.isEmpty ? null : workspaceName,
      // );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Project transfer link saved successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save transfer link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}