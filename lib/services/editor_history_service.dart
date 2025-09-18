import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/editor_command.dart';

class EditorHistoryService extends ChangeNotifier {
  static const int _maxHistorySize = 50;
  
  final Queue<EditorCommand> _undoStack = Queue<EditorCommand>();
  final Queue<EditorCommand> _redoStack = Queue<EditorCommand>();
  
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  
  String? get undoDescription => _undoStack.isEmpty ? null : _undoStack.last.description;
  String? get redoDescription => _redoStack.isEmpty ? null : _redoStack.last.description;
  
  void executeCommand(EditorCommand command) {
    command.execute();
    _undoStack.addLast(command);
    
    // Clear redo stack when new command is executed
    _redoStack.clear();
    
    // Maintain maximum history size
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeFirst();
    }
    
    notifyListeners();
  }
  
  void undo() {
    if (_undoStack.isEmpty) return;
    
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.addLast(command);
    
    // Maintain maximum history size for redo stack too
    if (_redoStack.length > _maxHistorySize) {
      _redoStack.removeFirst();
    }
    
    notifyListeners();
  }
  
  void redo() {
    if (_redoStack.isEmpty) return;
    
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.addLast(command);
    
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeFirst();
    }
    
    notifyListeners();
  }
  
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }
  
  void clearRedo() {
    _redoStack.clear();
    notifyListeners();
  }
  
  List<String> getUndoHistory() {
    return _undoStack.map((command) => command.description).toList();
  }
  
  List<String> getRedoHistory() {
    return _redoStack.map((command) => command.description).toList();
  }
}