import 'package:hive_flutter/hive_flutter.dart';

import '../../../entity/note_item_enity.dart';

class HiveManager {
  static Future<void> initHive() async {
    Hive.registerAdapter(NoteItemEntityAdapter());
    await Hive.initFlutter();
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    } else {
      return Hive.box<T>(boxName);
    }
  }

  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  static void registerAdapter(TypeAdapter adapter) {
    Hive.registerAdapter(adapter);
  }
}
