import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  
  const BaseScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}