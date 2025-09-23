import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/navigation_provider.dart';
import 'providers/projects_provider.dart';
import 'widgets/side_navigation.dart';
import 'widgets/project_selector.dart';
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
import 'screens/findings_visual_screen.dart';
import 'screens/documents_screen.dart' as docs;
import 'screens/screenshots_screen.dart';
import 'screens/assets_screen_classic.dart';
import 'screens/methodology_library_screen_classic.dart';
import 'screens/attack_plan_screen.dart';
import 'screens/questionnaire_screen.dart';
import 'dialogs/project_transfer_link_dialog.dart';
import 'constants/responsive_breakpoints.dart';

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
        return const MethodologyLibraryScreenClassic();
      case NavigationSection.methodologyDashboard:
        return const AttackPlanScreen();
      case NavigationSection.assets:
        return const AssetsScreenClassic();
      case NavigationSection.history:
        return const HistoryScreen();
      case NavigationSection.findings:
        return const FindingsVisualScreen();
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

  String _getTitleForSection(NavigationSection section, {String? projectName}) {
    // Build the title with project name if available
    if (projectName != null && projectName.isNotEmpty) {
      return 'Madness - $projectName';
    } else {
      return 'Madness';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            const SideNavigation(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final project = ref.watch(currentProjectProvider);
                                      return Text(
                                        _getTitleForSection(navigationState.currentSection, projectName: project?.name),
                                        style: Theme.of(context).textTheme.headlineSmall,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 24),
                                const Flexible(
                                  child: ProjectSelector(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Consumer(
                                builder: (context, ref, child) {
                                  final project = ref.watch(currentProjectProvider);
                                  return IconButton(
                                    icon: Icon(
                                      project?.hasTransferLink ?? false ? Icons.link : Icons.link_outlined,
                                      color: project?.hasTransferLink ?? false 
                                          ? Theme.of(context).colorScheme.primary 
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
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: _getScreenForSection(navigationState.currentSection, ref.watch(currentProjectProvider)?.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (context, ref, child) {
              final project = ref.watch(currentProjectProvider);
              return Text(_getTitleForSection(navigationState.currentSection, projectName: project?.name));
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
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
        drawer: const Drawer(
          child: SideNavigation(),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: _getScreenForSection(navigationState.currentSection, ref.watch(currentProjectProvider)?.id),
        ),
      );
    }
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
}