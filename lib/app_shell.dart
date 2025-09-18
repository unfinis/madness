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
import 'screens/all_screens.dart' hide ScreenshotsScreen, FindingsScreen;
import 'screens/findings_screen.dart';
import 'screens/credentials_screen.dart';
import 'screens/documents_screen.dart' as docs;
import 'screens/screenshots_screen.dart';
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
        return const MethodologyScreen();
      case NavigationSection.assets:
        return const AssetsScreen();
      case NavigationSection.credentials:
        return const CredentialsScreen();
      case NavigationSection.history:
        return const HistoryScreen();
      case NavigationSection.findings:
        return const FindingsScreen();
      case NavigationSection.attackChains:
        return const AttackChainsScreen();
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

  String _getTitleForSection(NavigationSection section) {
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
        return 'Pre-Engagement';
      case NavigationSection.expenses:
        return 'Expenses';
      case NavigationSection.contacts:
        return 'Contacts';
      case NavigationSection.scope:
        return 'Scope';
      case NavigationSection.documents:
        return 'Documents';
      case NavigationSection.travel:
        return 'Travel & Hotels';
      case NavigationSection.methodology:
        return 'Methodology';
      case NavigationSection.assets:
        return 'Assets';
      case NavigationSection.credentials:
        return 'Credentials';
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
                                Text(
                                  _getTitleForSection(navigationState.currentSection),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 24),
                                const ProjectSelector(),
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
          title: Text(_getTitleForSection(navigationState.currentSection)),
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
      applicationIcon: const Icon(Icons.security, size: 48),
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