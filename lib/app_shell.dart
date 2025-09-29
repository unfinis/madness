import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/navigation_provider.dart';
import 'providers/projects_provider.dart';
import 'widgets/side_navigation.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/scope_screen.dart';
import 'screens/comms_screen.dart';
import 'screens/travel_screen.dart';
import 'screens/history_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/agents_screen.dart';
import 'screens/plugins_screen.dart';
import 'screens/ingestors_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/findings_screen.dart';
import 'screens/documents_screen.dart' as docs;
import 'screens/screenshots_screen.dart';
import 'screens/assets_screen.dart';
import 'screens/methodology_library_screen.dart';
import 'screens/attack_plan_screen.dart';
import 'screens/questionnaire_screen.dart';
import 'dialogs/project_transfer_link_dialog.dart';
import 'dialogs/add_task_dialog.dart';
import 'dialogs/add_scope_segment_dialog.dart';
import 'dialogs/enhanced_finding_dialog.dart';
import 'dialogs/enhanced_asset_dialog.dart';
import 'dialogs/add_contact_dialog.dart';
import 'dialogs/upload_screenshot_dialog.dart';
import 'providers/comprehensive_asset_provider.dart';
import 'models/asset.dart';
import 'models/screenshot.dart';
import 'constants/responsive_breakpoints.dart';
import 'widgets/dynamic_top_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  Widget _getScreenForSection(NavigationSection section, String? projectId) {
    switch (section) {
      case NavigationSection.home:
        return const HomeScreen();
      case NavigationSection.dashboard:
        return const DashboardScreen();
      case NavigationSection.tasks:
        return const TasksScreen();
      case NavigationSection.comms:
        return const CommsScreen();
      case NavigationSection.checklist:
        return const QuestionnaireScreen();
      case NavigationSection.expenses:
        return ExpensesScreen(projectId: projectId ?? '');
      case NavigationSection.contacts:
        return ContactsScreen(projectId: projectId ?? '');
      case NavigationSection.scope:
        return const ScopeScreen();
      case NavigationSection.documents:
        return const docs.DocumentsScreen();
      case NavigationSection.travel:
        return const TravelScreen();
      case NavigationSection.methodology:
        return const MethodologyLibraryScreen();
      case NavigationSection.methodologyDashboard:
        return const AttackPlanScreen();
      case NavigationSection.assets:
        return const AssetsScreen();
      case NavigationSection.history:
        return const HistoryScreen();
      case NavigationSection.findings:
        return const FindingsScreen();
      case NavigationSection.attackChains:
        return const AttackPlanScreen();
      case NavigationSection.screenshots:
        return ScreenshotsScreen(projectId: projectId ?? '');
      case NavigationSection.reports:
        return const ReportsScreen();
      case NavigationSection.agents:
        return const AgentsScreen();
      case NavigationSection.plugins:
        return const PluginsScreen();
      case NavigationSection.ingestors:
        return const IngestorsScreen();
      case NavigationSection.settings:
        return const SettingsScreen();
    }
  }

  String _getScreenTitle(NavigationSection section) {
    switch (section) {
      case NavigationSection.home:
        return 'Home';
      case NavigationSection.dashboard:
        return 'Dashboard';
      case NavigationSection.tasks:
        return 'Tasks';
      case NavigationSection.comms:
        return 'Communications';
      case NavigationSection.checklist:
        return 'Pre-engagement Checklist';
      case NavigationSection.expenses:
        return 'Expenses';
      case NavigationSection.contacts:
        return 'Contacts';
      case NavigationSection.scope:
        return 'Scope';
      case NavigationSection.documents:
        return 'Documents';
      case NavigationSection.travel:
        return 'Travel';
      case NavigationSection.methodology:
        return 'Methodology Library';
      case NavigationSection.methodologyDashboard:
        return 'Attack Planning';
      case NavigationSection.assets:
        return 'Assets';
      case NavigationSection.history:
        return 'History';
      case NavigationSection.findings:
        return 'Findings';
      case NavigationSection.attackChains:
        return 'Attack Chains';
      case NavigationSection.screenshots:
        return 'Screenshots';
      case NavigationSection.reports:
        return 'Reports';
      case NavigationSection.agents:
        return 'Agents';
      case NavigationSection.plugins:
        return 'Plugins';
      case NavigationSection.ingestors:
        return 'Ingestors';
      case NavigationSection.settings:
        return 'Settings';
    }
  }

  List<TopBarAction> _getScreenActions(NavigationSection section, String? projectId, BuildContext context, WidgetRef ref) {
    switch (section) {
      case NavigationSection.tasks:
        return [
          TopBarAction(
            icon: Icons.upload,
            label: 'Import',
            onPressed: () => _handleTaskImport(context, ref),
          ),
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleTaskExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.add,
            label: 'Add Task',
            onPressed: () => _handleAddTask(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.scope:
        return [
          TopBarAction(
            icon: Icons.upload,
            label: 'Import',
            onPressed: () => _handleScopeImport(context, ref),
          ),
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleScopeExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.add,
            label: 'Add Segment',
            onPressed: () => _handleAddScopeSegment(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.contacts:
        return [
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleContactExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.add,
            label: 'Add Contact',
            onPressed: () => _handleAddContact(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.documents:
        return [
          TopBarAction(
            icon: Icons.upload,
            label: 'Upload',
            onPressed: () => _handleDocumentUpload(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.findings:
        return [
          TopBarAction(
            icon: Icons.account_tree_outlined,
            label: 'Template',
            onPressed: () => _handleFindingTemplate(context, ref),
          ),
          TopBarAction(
            icon: Icons.filter_list,
            label: 'Filters',
            onPressed: () => _handleFindingFilters(context, ref),
          ),
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleFindingExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.add,
            label: 'Add Finding',
            onPressed: () => _handleAddFinding(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.assets:
        return [
          TopBarAction(
            icon: Icons.refresh,
            label: 'Refresh',
            onPressed: () => _handleAssetRefresh(context, ref),
          ),
          TopBarAction(
            icon: Icons.upload,
            label: 'Import',
            onPressed: () => _handleAssetImport(context, ref),
          ),
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleAssetExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.account_tree,
            label: 'Relationships',
            onPressed: () => _handleAssetRelationships(context, ref),
          ),
          TopBarAction(
            icon: Icons.add,
            label: 'Add Asset',
            onPressed: () => _handleAddAsset(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.checklist:
        return [
          TopBarAction(
            icon: Icons.upload,
            label: 'Import',
            onPressed: () => _handleQuestionnaireImport(context, ref),
          ),
          TopBarAction(
            icon: Icons.download,
            label: 'Export',
            onPressed: () => _handleQuestionnaireExport(context, ref),
          ),
          TopBarAction(
            icon: Icons.calendar_month,
            label: 'Schedule KO Call',
            onPressed: () => _handleScheduleKickoffCall(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.screenshots:
        return [
          TopBarAction(
            icon: Icons.upload,
            label: 'Upload Screenshot',
            onPressed: () => _handleScreenshotUpload(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.methodology:
        return [
          TopBarAction(
            icon: Icons.add,
            label: 'Create Template',
            onPressed: () => _handleCreateMethodology(context, ref),
            isPrimary: true,
          ),
        ];
      case NavigationSection.attackChains:
        return [
          TopBarAction(
            icon: Icons.refresh,
            label: 'Refresh',
            onPressed: () => _handleAttackPlanRefresh(context, ref),
          ),
          TopBarAction(
            icon: Icons.auto_fix_high,
            label: 'Generate Actions',
            onPressed: () => _handleGenerateActions(context, ref),
          ),
          TopBarAction(
            icon: Icons.file_download,
            label: 'Export Plan',
            onPressed: () => _handleExportPlan(context, ref),
          ),
          TopBarAction(
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () => _handlePlanSettings(context, ref),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getScreenTitle(navigationState.currentSection)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ...TopBarActions(
            actions: _getScreenActions(navigationState.currentSection, ref.watch(currentProjectProvider)?.id, context, ref),
          ).buildActions(context),
          Consumer(
            builder: (context, ref, child) {
              final project = ref.watch(currentProjectProvider);
              return IconButton(
                icon: Icon(
                  project?.hasTransferLink ?? false ? Icons.link : Icons.link_outlined,
                  color: project?.hasTransferLink ?? false
                      ? Colors.white
                      : null,
                ),
                onPressed: () => _showProjectTransferLinkDialog(context),
                tooltip: project?.hasTransferLink ?? false
                    ? 'Manage Project Transfer Link'
                    : 'Add Project Transfer Link',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotificationsMenu(context);
            },
            tooltip: 'Notifications',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'User Menu',
            onSelected: (value) {
              _handleUserMenuSelection(context, ref, value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 12),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'account',
                child: Row(
                  children: [
                    Icon(Icons.manage_accounts, size: 20),
                    SizedBox(width: 12),
                    Text('Account Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(Icons.palette, size: 20),
                    SizedBox(width: 12),
                    Text('Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'notifications',
                child: Row(
                  children: [
                    Icon(Icons.notifications, size: 20),
                    SizedBox(width: 12),
                    Text('Notification Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Help & Support'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 12),
                    Text('About'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: isDesktop ? null : const Drawer(
        child: SideNavigation(),
      ),
      body: Row(
        children: [
          if (isDesktop) const SideNavigation(),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: _getScreenForSection(navigationState.currentSection, ref.watch(currentProjectProvider)?.id),
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectTransferLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProjectTransferLinkDialog(),
    );
  }

  void _handleUserMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile page coming soon')),
        );
        break;
      case 'account':
        // Navigate to account settings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account settings coming soon')),
        );
        break;
      case 'theme':
        // Show theme selector
        _showThemeDialog(context);
        break;
      case 'notifications':
        // Navigate to notification settings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification settings coming soon')),
        );
        break;
      case 'help':
        // Show help
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help & Support coming soon')),
        );
        break;
      case 'about':
        // Show about dialog
        _showAboutDialog(context);
        break;
      case 'logout':
        // Handle logout
        _showLogoutConfirmation(context);
        break;
    }
  }

  // Questionnaire top bar action handlers
  void _handleQuestionnaireImport(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import questionnaire functionality coming soon')),
    );
  }

  void _handleQuestionnaireExport(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export questionnaire functionality coming soon')),
    );
  }

  void _handleScheduleKickoffCall(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule kickoff call functionality coming soon')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Screenshots screen action handlers
  void _handleScreenshotUpload(BuildContext context, WidgetRef ref) async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      await showDialog<Screenshot>(
        context: context,
        builder: (context) => UploadScreenshotDialog(
          projectId: currentProject.id,
        ),
      );
      // Dialog handles its own success feedback
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Methodology screen action handlers
  void _handleCreateMethodology(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create methodology template functionality coming soon')),
    );
  }

  // Attack Plan screen action handlers
  void _handleAttackPlanRefresh(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refresh attack plan actions functionality coming soon')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handleGenerateActions(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate new actions functionality coming soon')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handleExportPlan(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export attack plan functionality coming soon')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handlePlanSettings(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan settings functionality coming soon')),
    );
  }

  void _showNotificationsMenu(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications panel coming soon')),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Light theme selected')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark theme selected')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_system_daydream),
              title: const Text('System'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System theme selected')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Madness',
      applicationVersion: '1.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/icon/app_icon.png',
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      children: const [
        Text('Penetration Testing Platform'),
        SizedBox(height: 8),
        Text('A comprehensive tool for managing penetration testing engagements.'),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // Handler methods for screen actions - these call the actual functionality from the screens

  void _handleTaskImport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to tasks screen import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task import functionality coming soon')),
    );
  }

  void _handleTaskExport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to tasks screen export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task export functionality coming soon')),
    );
  }

  void _handleAddTask(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
  }

  void _handleScopeImport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to scope screen import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scope import functionality coming soon')),
    );
  }

  void _handleScopeExport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to scope screen export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scope export functionality coming soon')),
    );
  }

  void _handleAddScopeSegment(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddScopeSegmentDialog(),
    );
  }

  void _handleContactExport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to contacts screen export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact export functionality coming soon')),
    );
  }

  void _handleAddContact(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a project first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AddContactDialog(projectId: currentProject.id),
    );
  }

  void _handleDocumentUpload(BuildContext context, WidgetRef ref) {
    // TODO: Wire to documents screen upload dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document upload functionality coming soon')),
    );
  }

  void _handleFindingTemplate(BuildContext context, WidgetRef ref) {
    // TODO: Wire to findings screen template functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding template functionality coming soon')),
    );
  }

  void _handleFindingFilters(BuildContext context, WidgetRef ref) {
    // TODO: Wire to findings screen filter toggle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding filters functionality coming soon')),
    );
  }

  void _handleFindingExport(BuildContext context, WidgetRef ref) {
    // TODO: Wire to findings screen export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding export functionality coming soon')),
    );
  }

  void _handleAddFinding(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project selected')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => EnhancedFindingDialog(
        projectId: currentProject.id,
        finding: null,
      ),
    );
  }

  void _handleAssetRefresh(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ref.read(assetNotifierProvider(currentProject.id).notifier).refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refreshing assets...')),
      );
    }
  }

  void _handleAssetImport(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature coming soon')),
    );
  }

  void _handleAssetExport(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon')),
    );
  }

  void _handleAssetRelationships(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relationship visualization coming soon')),
    );
  }

  void _handleAddAsset(BuildContext context, WidgetRef ref) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project selected')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => EnhancedAssetDialog(
        projectId: currentProject.id,
        mode: AssetDialogMode.create,
        initialType: AssetType.networkSegment,
      ),
    );
  }
}