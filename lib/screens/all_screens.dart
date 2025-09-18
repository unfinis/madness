import 'package:flutter/material.dart';
import 'base_screen.dart';

class CommsScreen extends StatelessWidget {
  const CommsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Communications', icon: Icons.chat);
}

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Pre-Engagement', icon: Icons.checklist);
}



// ScopeScreen is imported from scope_screen.dart

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Documents', icon: Icons.description);
}

class TravelScreen extends StatelessWidget {
  const TravelScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Travel & Hotels', icon: Icons.flight);
}

class MethodologyScreen extends StatelessWidget {
  const MethodologyScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Methodology', icon: Icons.search);
}

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Assets', icon: Icons.computer);
}

// CredentialsScreen is implemented in credentials_screen.dart

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'History', icon: Icons.history);
}

class FindingsScreen extends StatelessWidget {
  const FindingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Findings', icon: Icons.bug_report);
}

class AttackChainsScreen extends StatelessWidget {
  const AttackChainsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Attack Chains', icon: Icons.link);
}

class ScreenshotsScreen extends StatelessWidget {
  const ScreenshotsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Screenshots', icon: Icons.photo_camera);
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Reports', icon: Icons.article);
}

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Agents', icon: Icons.smart_toy);
}

class PluginsScreen extends StatelessWidget {
  const PluginsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Plugins', icon: Icons.extension);
}

class IngestorsScreen extends StatelessWidget {
  const IngestorsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Ingestors', icon: Icons.download);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Settings', icon: Icons.settings);
}