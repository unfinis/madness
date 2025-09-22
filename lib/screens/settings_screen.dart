import 'package:flutter/material.dart';
import 'base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const BaseScreen(title: 'Settings', icon: Icons.settings);
}