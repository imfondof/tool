import 'package:hive_flutter/hive_flutter.dart';

import 'storage_service.dart';

class HiveStorageService implements StorageService {
  static const String settingsBoxName = 'settings';
  late final Box<dynamic> _settingsBox;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  @override
  T? get<T>(String key) => _settingsBox.get(key) as T?;

  @override
  Future<void> set<T>(String key, T value) => _settingsBox.put(key, value);

  @override
  Future<void> remove(String key) => _settingsBox.delete(key);

  @override
  Future<void> clear() => _settingsBox.clear();
}
