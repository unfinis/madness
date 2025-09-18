import '../models/editor_layer.dart';

abstract class EditorCommand {
  void execute();
  void undo();
  String get description;
}

class AddLayerCommand implements EditorCommand {
  final EditorLayer layer;
  final Function(EditorLayer) onAdd;
  final Function(String) onRemove;

  AddLayerCommand(this.layer, this.onAdd, this.onRemove);

  @override
  void execute() => onAdd(layer);

  @override
  void undo() => onRemove(layer.id);

  @override
  String get description => 'Add ${layer.name}';
}

class RemoveLayerCommand implements EditorCommand {
  final EditorLayer layer;
  final Function(EditorLayer) onAdd;
  final Function(String) onRemove;

  RemoveLayerCommand(this.layer, this.onAdd, this.onRemove);

  @override
  void execute() => onRemove(layer.id);

  @override
  void undo() => onAdd(layer);

  @override
  String get description => 'Remove ${layer.name}';
}

class ModifyLayerCommand implements EditorCommand {
  final EditorLayer oldLayer;
  final EditorLayer newLayer;
  final Function(EditorLayer) onModify;

  ModifyLayerCommand(this.oldLayer, this.newLayer, this.onModify);

  @override
  void execute() => onModify(newLayer);

  @override
  void undo() => onModify(oldLayer);

  @override
  String get description => 'Modify ${oldLayer.name}';
}

class MoveLayerCommand implements EditorCommand {
  final String layerId;
  final int oldIndex;
  final int newIndex;
  final Function(String, int, int) onMove;

  MoveLayerCommand(this.layerId, this.oldIndex, this.newIndex, this.onMove);

  @override
  void execute() => onMove(layerId, oldIndex, newIndex);

  @override
  void undo() => onMove(layerId, newIndex, oldIndex);

  @override
  String get description => 'Move layer';
}

class CompositeCommand implements EditorCommand {
  final List<EditorCommand> commands;
  final String _description;

  CompositeCommand(this.commands, this._description);

  @override
  void execute() {
    for (final command in commands) {
      command.execute();
    }
  }

  @override
  void undo() {
    for (final command in commands.reversed) {
      command.undo();
    }
  }

  @override
  String get description => _description;
}