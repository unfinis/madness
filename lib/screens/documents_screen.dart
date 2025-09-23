import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/document.dart';
import '../providers/document_provider.dart';
import '../services/document_service.dart';
import '../constants/app_spacing.dart';
import '../constants/responsive_breakpoints.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final _searchController = TextEditingController();
  final _documentService = DocumentService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _activeFilter = 'all';
  DocumentType _selectedCategory = DocumentType.other;
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isDragging = false;

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(filteredDocumentsProvider);
    final summary = ref.watch(documentSummaryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    final isWideDesktop = screenWidth > 1200;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWideDesktop ? 20.0 : (isDesktop ? 24.0 : 16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAssetsHeader(context, summary),
            SizedBox(height: isWideDesktop ? 16 : 24),
            _buildFiltersSection(context),
            SizedBox(height: isWideDesktop ? 16 : 24),
            _buildDocumentsTable(context, documents),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsHeader(BuildContext context, Map<String, int> summary) {
    return Column(
      children: [
        // Assets-style chip summary
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatChip('Total', summary['total'] ?? 0, Icons.folder_outlined, Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Signed', summary['approved'] ?? 0, Icons.check_circle, Colors.green),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Pending', summary['drafts'] ?? 0, Icons.pending, Colors.orange),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Confidential', summary['confidential'] ?? 0, Icons.security, Colors.red),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Authorization', summary['authorization'] ?? 0, Icons.verified_user, Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Technical', summary['technical'] ?? 0, Icons.engineering, Colors.purple),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        // Action Buttons
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: () => _showUploadDialog(context),
                icon: const Icon(Icons.upload),
                label: const Text('Upload'),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildFiltersSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filters
          Row(
            children: [
              Text(
                'Category:',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.hGapMD,
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    _buildFilterButton('all', 'All'),
                    _buildFilterButton('presales', 'Presales'),
                    _buildFilterButton('contracts', 'Contracts'),
                    _buildFilterButton('reports', 'Reports'),
                    _buildFilterButton('pdf', 'PDF'),
                    _buildFilterButton('docx', 'Word'),
                    _buildFilterButton('xlsx', 'Excel'),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          // Search Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search documents, descriptions...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(documentFiltersProvider.notifier).updateSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: (value) {
                    ref.read(documentFiltersProvider.notifier).updateSearchQuery(value);
                  },
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final theme = Theme.of(context);
    final isActive = _activeFilter == value;

    return FilterChip(
      selected: isActive,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _activeFilter = value;
        });
        // TODO: Apply filter to documents
      },
      selectedColor: theme.colorScheme.secondaryContainer,
      checkmarkColor: theme.colorScheme.onSecondaryContainer,
    );
  }

  Widget _buildDocumentsTable(BuildContext context, List<Document> documents) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: AppSpacing.lg,
          horizontalMargin: AppSpacing.lg,
          showCheckboxColumn: true,
          columns: const [
            DataColumn(
              label: Text('Document Name'),
              tooltip: 'Sort by document name',
            ),
            DataColumn(
              label: Text('Category'),
              tooltip: 'Sort by category',
            ),
            DataColumn(
              label: Text('Size'),
              tooltip: 'Sort by file size',
            ),
            DataColumn(
              label: Text('Date'),
              tooltip: 'Sort by date modified',
            ),
            DataColumn(
              label: Text('Status'),
              tooltip: 'Sort by status',
            ),
            DataColumn(
              label: Text('Description'),
            ),
            DataColumn(
              label: Text('Actions'),
            ),
          ],
          rows: documents.map((document) => _buildDocumentRow(document)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDocumentRow(Document document) {
    final theme = Theme.of(context);

    return DataRow(
      onSelectChanged: (selected) {
        // TODO: Handle row selection
      },
      cells: [
        // Document Name
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                document.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () => _openDocumentDetails(document),
        ),
        // Category
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs / 2,
            ),
            decoration: BoxDecoration(
              color: _getCategoryColor(document.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.chipRadius),
            ),
            child: Text(
              document.typeDisplayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getCategoryColor(document.type),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Size
        DataCell(Text(document.displaySize)),
        // Date
        DataCell(Text(_formatDate(document.dateModified))),
        // Status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs / 2,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(document.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.chipRadius),
              border: Border.all(
                color: _getStatusColor(document.status).withOpacity(0.3),
              ),
            ),
            child: Text(
              document.statusDisplayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(document.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Description
        DataCell(
          Text(
            document.description.isNotEmpty ? document.description : '—',
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Actions
        DataCell(
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'open',
                child: ListTile(
                  leading: Icon(Icons.open_in_new),
                  title: Text('Open'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Download'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    'Delete',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) => _handleDocumentAction(document, value),
            child: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(DocumentType type) {
    final theme = Theme.of(context);
    switch (type) {
      case DocumentType.authorisationForms:
        return theme.colorScheme.primary;
      case DocumentType.statementOfWork:
        return Colors.purple;
      case DocumentType.presalesNotes:
        return Colors.blue;
      case DocumentType.scopingDocuments:
        return Colors.orange;
      case DocumentType.technicalDocuments:
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getCategoryIcon(DocumentType type) {
    // Icons removed for cleaner UI design
    return '';
  }

  Color _getStatusColor(DocumentStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case DocumentStatus.draft:
        return Colors.orange;
      case DocumentStatus.approved:
        return Colors.green;
      case DocumentStatus.inReview:
        return theme.colorScheme.primary;
      case DocumentStatus.finalized:
        return theme.colorScheme.onSurfaceVariant;
      case DocumentStatus.archived:
        return theme.colorScheme.outline;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _openDocumentDetails(Document document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${document.name}"...'),
      ),
    );
  }

  Future<void> _openDocument(Document document) async {
    try {
      if (document.filePath == null || !File(document.filePath!).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File not found for "${document.name}"'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final Uri fileUri = Uri.file(document.filePath!);
      
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opened "${document.name}" in default application'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No default application found for "${document.name}"'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open "${document.name}": $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDocumentAction(Document document, String action) {
    switch (action) {
      case 'open':
        _openDocument(document);
        break;
      case 'download':
        _downloadDocument(document);
        break;
      case 'share':
        _shareDocument(document);
        break;
      case 'edit':
        _editDocument(document);
        break;
      case 'delete':
        _showDeleteConfirmation(document);
        break;
    }
  }

  Future<void> _downloadDocument(Document document) async {
    try {
      if (document.filePath == null || !File(document.filePath!).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File not found for "${document.name}"'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Let user choose where to save the file
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save ${document.name}',
        fileName: document.name + (document.fileExtension != null ? '.${document.fileExtension}' : ''),
      );

      if (outputPath != null) {
        final sourceFile = File(document.filePath!);
        await sourceFile.copy(outputPath);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloaded "${document.name}" successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download "${document.name}": $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _shareDocument(Document document) {
    // For now, show file location - in a real app this would use platform sharing
    if (document.filePath != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Share "${document.name}"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('File location:'),
              AppSpacing.vGapSM,
              SelectableText(
                document.filePath!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              AppSpacing.vGapLG,
              const Text('In a production app, this would integrate with platform sharing.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file path available for "${document.name}"')),
      );
    }
  }

  void _editDocument(Document document) {
    // Pre-populate the upload dialog with current document data
    _titleController.text = document.name;
    _descriptionController.text = document.description;
    _selectedCategory = document.type;
    _selectedFileName = document.hasFile ? path.basename(document.filePath!) : null;
    _selectedFilePath = document.filePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool isFormValid = _titleController.text.isNotEmpty;
          
          return AlertDialog(
            title: Row(
              children: [
                const Text('✏️ Edit Document'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document Category
                  Text(
                    'Document Category',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  AppSpacing.vGapSM,
                  DropdownButtonFormField<DocumentType>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: DocumentType.authorisationForms, child: Text('Authorisation Forms')),
                      DropdownMenuItem(value: DocumentType.statementOfWork, child: Text('Statement of Work')),
                      DropdownMenuItem(value: DocumentType.presalesNotes, child: Text('Presales Notes')),
                      DropdownMenuItem(value: DocumentType.scopingDocuments, child: Text('Scoping Documents')),
                      DropdownMenuItem(value: DocumentType.technicalDocuments, child: Text('Technical Documents')),
                      DropdownMenuItem(value: DocumentType.other, child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedCategory = value ?? DocumentType.other;
                      });
                    },
                  ),
                  AppSpacing.vGapLG,
                  
                  // Document Title
                  Text(
                    'Document Title',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  AppSpacing.vGapSM,
                  TextField(
                    controller: _titleController,
                    onChanged: (value) {
                      setModalState(() {});
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter document name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  AppSpacing.vGapLG,
                  
                  // Current File (read-only)
                  Text(
                    'Current File',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  AppSpacing.vGapSM,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        AppSpacing.hGapSM,
                        Expanded(
                          child: Text(
                            _selectedFileName ?? 'No file attached',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapLG,
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  AppSpacing.vGapSM,
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Brief description of the document...',
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: isFormValid
                  ? () async {
                      Navigator.of(context).pop();
                      await _updateDocument(document);
                    }
                  : null,
                child: const Text('Update Document'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateDocument(Document originalDocument) async {
    try {
      final updatedDocument = originalDocument.copyWith(
        name: _titleController.text,
        description: _descriptionController.text.isNotEmpty 
          ? _descriptionController.text 
          : originalDocument.description,
        type: _selectedCategory,
        dateModified: DateTime.now(),
      );

      ref.read(documentProvider.notifier).updateDocument(updatedDocument);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated "${_titleController.text}" successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(documentProvider.notifier).deleteDocument(document.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document "${document.name}" deleted')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  void _showUploadDialog(BuildContext context) {
    // Reset form fields
    _titleController.clear();
    _descriptionController.clear();
    _selectedCategory = DocumentType.other;
    _selectedFileName = null;
    _selectedFilePath = null;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool isFormValid = _selectedFileName != null && _titleController.text.isNotEmpty;
          
          return AlertDialog(
          title: Row(
            children: [
              const Text('Upload Document'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document Category
                Text(
                  'Document Category',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                AppSpacing.vGapSM,
                DropdownButtonFormField<DocumentType>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(value: DocumentType.authorisationForms, child: Text('Authorisation Forms')),
                    DropdownMenuItem(value: DocumentType.statementOfWork, child: Text('Statement of Work')),
                    DropdownMenuItem(value: DocumentType.presalesNotes, child: Text('Presales Notes')),
                    DropdownMenuItem(value: DocumentType.scopingDocuments, child: Text('Scoping Documents')),
                    DropdownMenuItem(value: DocumentType.technicalDocuments, child: Text('Technical Documents')),
                    DropdownMenuItem(value: DocumentType.other, child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? DocumentType.other;
                    });
                  },
                ),
                AppSpacing.vGapLG,
                
                // Document Title
                Text(
                  'Document Title',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                AppSpacing.vGapSM,
                TextField(
                  controller: _titleController,
                  onChanged: (value) {
                    setModalState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter document name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                AppSpacing.vGapLG,
                
                // File Upload Zone
                Text(
                  'File Upload',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                AppSpacing.vGapSM,
                DropTarget(
                  onDragDone: (details) async {
                    await _handleDroppedFiles(details, setModalState);
                  },
                  onDragEntered: (details) {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onDragExited: (details) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: InkWell(
                    onTap: () async {
                      await _selectFile(setModalState);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isDragging 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                          style: BorderStyle.solid,
                          width: _isDragging ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _isDragging
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 32,
                            color: _isDragging 
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary,
                          ),
                          AppSpacing.vGapSM,
                          Text(
                            _selectedFileName ?? (_isDragging ? 'Drop file here' : 'Click to select file or drag & drop'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _selectedFileName != null 
                                ? Theme.of(context).colorScheme.primary
                                : (_isDragging 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant),
                              fontWeight: _selectedFileName != null || _isDragging ? FontWeight.w500 : null,
                            ),
                          ),
                          if (_selectedFileName == null && !_isDragging) ...[
                            AppSpacing.vGapXS,
                            Text(
                              'PDF, DOC, DOCX, XLS, XLSX, Images',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.vGapLG,
                
                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                AppSpacing.vGapSM,
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Brief description of the document...',
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: isFormValid
                ? () async {
                    Navigator.of(context).pop();
                    await _uploadDocumentWithDetails();
                  }
                : null,
              child: const Text('Upload Document'),
            ),
          ],
          );
        },
      ),
    );
  }


  Future<void> _selectFile(StateSetter setState) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'gif', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final fileName = result.files.first.name;
        final filePath = result.files.first.path;
        
        // Extract filename without extension for title
        final nameWithoutExtension = path.basenameWithoutExtension(fileName);
        
        setState(() {
          _selectedFileName = fileName;
          _selectedFilePath = filePath;
          // Auto-populate title if it's empty
          if (_titleController.text.isEmpty) {
            _titleController.text = nameWithoutExtension;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDroppedFiles(DropDoneDetails details, StateSetter setState) async {
    try {
      if (details.files.isNotEmpty) {
        final file = details.files.first;
        final fileName = path.basename(file.path);
        
        // Check if file extension is allowed
        final extension = path.extension(fileName).replaceFirst('.', '').toLowerCase();
        final allowedExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'gif', 'txt'];
        
        if (!allowedExtensions.contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File type "$extension" is not supported'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Extract filename without extension for title
        final nameWithoutExtension = path.basenameWithoutExtension(fileName);
        
        setState(() {
          _selectedFileName = fileName;
          _selectedFilePath = file.path;
          // Auto-populate title if it's empty
          if (_titleController.text.isEmpty) {
            _titleController.text = nameWithoutExtension;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process dropped file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadDocumentWithDetails() async {
    try {
      if (_selectedFilePath == null || _titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a file and enter a title')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading document...')),
      );

      final document = await _documentService.saveDocumentFile(
        _selectedFilePath!,
        _selectedFileName!,
        _selectedCategory,
      );

      if (document != null) {
        // Update document with custom details
        final updatedDocument = document.copyWith(
          name: _titleController.text,
          description: _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : 'Uploaded document',
          type: _selectedCategory,
        );

        ref.read(documentProvider.notifier).addDocument(updatedDocument);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully uploaded "${_titleController.text}"'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save document'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}