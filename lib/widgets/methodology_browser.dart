import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_spacing.dart';
import '../providers/navigation_provider.dart';
import '../dialogs/comprehensive_methodology_detail_dialog.dart';
import '../dialogs/trigger_editor_dialog.dart';

class MethodologyBrowser extends ConsumerStatefulWidget {
  const MethodologyBrowser({super.key});

  @override
  ConsumerState<MethodologyBrowser> createState() => _MethodologyBrowserState();
}

class _MethodologyBrowserState extends ConsumerState<MethodologyBrowser> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showOnlyFavorites = false;

  final List<String> _categories = [
    'All',
    'reconnaissance',
    'exploitation',
    'post_exploitation',
    'privilege_escalation',
    'lateral_movement',
    'persistence',
    'defense_evasion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Methodology Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_tree),
            tooltip: 'View Attack Graph',
            onPressed: () => _navigateToAttackGraph(),
          ),
          IconButton(
            icon: const Icon(Icons.build),
            tooltip: 'Create New Trigger',
            onPressed: () => _showTriggerEditor(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Methodology',
            onPressed: () => _showCreateMethodologyDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _buildMethodologyGrid(),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search Methodologies',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Favorites Only'),
                  value: _showOnlyFavorites,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyFavorites = value ?? false;
                    });
                  },
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodologyGrid() {
    // This would be connected to your methodology provider
    final methodologies = _getFilteredMethodologies();

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: methodologies.length,
      itemBuilder: (context, index) {
        final methodology = methodologies[index];
        return _buildMethodologyCard(methodology);
      },
    );
  }

  Widget _buildMethodologyCard(Map<String, dynamic> methodology) {
    final category = methodology['category'] ?? 'unknown';
    final riskLevel = methodology['risk_level'] ?? 'low';

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _openMethodologyDetails(methodology),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      methodology['name'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildRiskBadge(riskLevel),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildCategoryChip(category),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Text(
                  methodology['description'] ?? 'No description available',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Theme.of(context).hintColor),
                  const SizedBox(width: 4),
                  Text(
                    methodology['estimated_duration'] ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.open_in_new, size: 20),
                    onPressed: () => _openMethodologyDetails(methodology),
                    tooltip: 'View Details',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskBadge(String riskLevel) {
    Color color;
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        color = Theme.of(context).colorScheme.error;
        break;
      case 'high':
        color = Theme.of(context).colorScheme.error.withOpacity(0.8);
        break;
      case 'medium':
        color = Theme.of(context).colorScheme.tertiary;
        break;
      case 'low':
        color = Theme.of(context).colorScheme.primary;
        break;
      default:
        color = Theme.of(context).hintColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        riskLevel.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Chip(
      label: Text(
        category.replaceAll('_', ' ').toUpperCase(),
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      side: BorderSide(color: Theme.of(context).primaryColor),
    );
  }


  // Mock data methods
  List<Map<String, dynamic>> _getFilteredMethodologies() {
    final allMethodologies = [
      {
        'id': 'comprehensive_vdi_breakout',
        'name': 'Comprehensive VDI Breakout',
        'category': 'post_exploitation',
        'description': 'Advanced VDI/RDP breakout techniques for Citrix, VMware Horizon, and Microsoft RDS environments',
        'risk_level': 'high',
        'estimated_duration': '4-8h',
      },
      {
        'id': 'credential_testing',
        'name': 'Credential Testing',
        'category': 'exploitation',
        'description': 'Test harvested credentials against various services and protocols',
        'risk_level': 'medium',
        'estimated_duration': '1-2h',
      },
      {
        'id': 'smb_enumeration',
        'name': 'SMB Enumeration',
        'category': 'reconnaissance',
        'description': 'Comprehensive SMB share enumeration and null session testing',
        'risk_level': 'low',
        'estimated_duration': '30m',
      },
      {
        'id': 'port_scanning',
        'name': 'Port Scanning',
        'category': 'reconnaissance',
        'description': 'Comprehensive TCP/UDP port scanning with service detection',
        'risk_level': 'low',
        'estimated_duration': '15-30m',
      },
    ];

    return allMethodologies.where((methodology) {
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = (methodology['name'] as String).toLowerCase();
        final description = (methodology['description'] as String).toLowerCase();
        if (!name.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Filter by category
      if (_selectedCategory != 'All') {
        if (methodology['category'] != _selectedCategory) {
          return false;
        }
      }

      return true;
    }).toList();
  }


  // Event handlers
  void _openMethodologyDetails(Map<String, dynamic> methodology) {
    showDialog(
      context: context,
      builder: (context) => MethodologyDetailDialog(
        methodology: methodology,
        isFromLibrary: true,
      ),
    );
  }

  void _showCreateMethodologyDialog() {
    // TODO: Implement methodology creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Methodology creation coming soon')),
    );
  }

  void _showTriggerEditor() {
    showDialog(
      context: context,
      builder: (context) => TriggerEditorDialog(
        onSave: (trigger) {
          // TODO: Save the trigger to trigger provider
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trigger "${trigger.name}" created successfully')),
          );
        },
      ),
    );
  }

  void _navigateToAttackGraph() {
    ref.read(navigationProvider.notifier).navigateTo(NavigationSection.methodologyDashboard);
  }
}