// Minimal test to isolate the syntax issue

import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {

  MouseCursor _getCursorForTool() {
    return SystemMouseCursors.basic;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: _getCursorForTool(),
        onHover: (event) {
          // Some content
        },
        child: Container(),
      ),
    );
  }
}