import 'dart:convert';
import 'package:hive/hive.dart';
import '../../data/models/game_state.dart';

class SaveService {
  static const String _boxName = 'saves';
  static const String _currentSaveKey = 'current_save';
  static const String _autoSaveKey = 'auto_save';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveGame(GameState state) async {
    final json = jsonEncode(state.toJson());
    await _box.put(_currentSaveKey, json);
  }

  Future<void> autoSave(GameState state) async {
    final json = jsonEncode(state.toJson());
    await _box.put(_autoSaveKey, json);
  }

  Future<GameState?> loadGame() async {
    final json = _box.get(_currentSaveKey) as String?;
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  Future<GameState?> loadAutoSave() async {
    final json = _box.get(_autoSaveKey) as String?;
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  bool get hasSave => _box.containsKey(_currentSaveKey);
  bool get hasAutoSave => _box.containsKey(_autoSaveKey);

  Future<void> deleteSave() async {
    await _box.delete(_currentSaveKey);
  }

  Future<void> deleteAutoSave() async {
    await _box.delete(_autoSaveKey);
  }

  String exportToJson(GameState state) {
    return jsonEncode(state.toJson());
  }

  GameState? importFromJson(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }
}
