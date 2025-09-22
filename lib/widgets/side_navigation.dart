import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../constants/responsive_breakpoints.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final NavigationSection section;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.section,
  });
}

class NavigationGroup {
  final String title;
  final List<NavigationItem> items;

  NavigationGroup({
    required this.title,
    required this.items,
  });
}

class SideNavigation extends ConsumerWidget {
  const SideNavigation({super.key});

  List<NavigationGroup> get navigationGroups => [
        NavigationGroup(
          title: 'MAIN',
          items: [
            NavigationItem(label: 'Home', icon: Icons.home, section: NavigationSection.home),
          ],
        ),
        NavigationGroup(
          title: 'ENGAGEMENT',
          items: [
            NavigationItem(label: 'Dashboard', icon: Icons.dashboard, section: NavigationSection.dashboard),
            NavigationItem(label: 'Tasks', icon: Icons.task_alt, section: NavigationSection.tasks),
            NavigationItem(label: 'Communications', icon: Icons.chat, section: NavigationSection.comms),
            NavigationItem(label: 'Pre-Engagement', icon: Icons.checklist, section: NavigationSection.checklist),
            NavigationItem(label: 'Expenses', icon: Icons.credit_card, section: NavigationSection.expenses),
            NavigationItem(label: 'Contacts', icon: Icons.people, section: NavigationSection.contacts),
            NavigationItem(label: 'Scope', icon: Icons.adjust, section: NavigationSection.scope),
            NavigationItem(label: 'Documents', icon: Icons.description, section: NavigationSection.documents),
            NavigationItem(label: 'Travel & Hotels', icon: Icons.flight, section: NavigationSection.travel),
          ],
        ),
        NavigationGroup(
          title: 'TESTING',
          items: [
            NavigationItem(label: 'Attack Plan', icon: Icons.account_tree, section: NavigationSection.methodologyDashboard),
            NavigationItem(label: 'Methodology Library', icon: Icons.library_books, section: NavigationSection.methodology),
            NavigationItem(label: 'Assets', icon: Icons.computer, section: NavigationSection.assets),
            NavigationItem(label: 'Asset Management', icon: Icons.storage, section: NavigationSection.comprehensiveAssets),
            NavigationItem(label: 'Trigger Monitoring', icon: Icons.gps_fixed, section: NavigationSection.triggerEvaluation),
            NavigationItem(label: 'Credentials', icon: Icons.key, section: NavigationSection.credentials),
            NavigationItem(label: 'History', icon: Icons.history, section: NavigationSection.history),
          ],
        ),
        NavigationGroup(
          title: 'RESULTS',
          items: [
            NavigationItem(label: 'Findings', icon: Icons.bug_report, section: NavigationSection.findings),
            NavigationItem(label: 'Screenshots', icon: Icons.photo_camera, section: NavigationSection.screenshots),
            NavigationItem(label: 'Reports', icon: Icons.article, section: NavigationSection.reports),
          ],
        ),
        NavigationGroup(
          title: 'TOOLS',
          items: [
            NavigationItem(label: 'Agents', icon: Icons.smart_toy, section: NavigationSection.agents),
            NavigationItem(label: 'Plugins', icon: Icons.extension, section: NavigationSection.plugins),
            NavigationItem(label: 'Ingestors', icon: Icons.download, section: NavigationSection.ingestors),
            NavigationItem(label: 'Settings', icon: Icons.settings, section: NavigationSection.settings),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    final isNarrow = ResponsiveBreakpoints.isNarrowDesktop(screenWidth);
    
    // Adjust sidebar width based on available space
    double sidebarWidth;
    if (!isDesktop) {
      sidebarWidth = double.infinity;
    } else if (isNarrow) {
      sidebarWidth = 240; // Narrower for small desktop windows
    } else {
      sidebarWidth = 280; // Full width for wide desktops
    }
    
    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isNarrow ? 12 : 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    width: isNarrow ? 24 : 32,
                    height: isNarrow ? 24 : 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Icon(
                        Icons.security,
                        color: Colors.white,
                        size: isNarrow ? 24 : 32,
                      );
                    },
                  ),
                ),
                if (!isNarrow) ...[
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Text(
                      'MADNESS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'MADNESS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: navigationGroups.map((group) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        group.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...group.items.map((item) {
                      final isSelected = navigationState.currentSection == item.section;
                      return ListTile(
                        dense: isNarrow,
                        visualDensity: isNarrow ? VisualDensity.compact : null,
                        leading: Icon(
                          item.icon,
                          size: isNarrow ? 20 : 24,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: isNarrow ? 13 : 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: isSelected,
                        selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        onTap: () {
                          ref.read(navigationProvider.notifier).navigateTo(item.section);
                          if (!isDesktop) {
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}