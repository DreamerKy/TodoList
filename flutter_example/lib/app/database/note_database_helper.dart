// 记事本记录表
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../entity/note_item_enity.dart';
import '../constants.dart';
import 'manager/hive_manager.dart';

NoteDataBaseHelper noteDataBaseHelper = NoteDataBaseHelper();

class NoteDataBaseHelper {
  NoteDataBaseHelper._constructor();

  static final NoteDataBaseHelper _instance = NoteDataBaseHelper._constructor();

  factory NoteDataBaseHelper() => _instance;

  late Box<NoteItemEntity> noteItemBox;

  Future<Box<NoteItemEntity>> openNoteBox() async {
    noteItemBox = await HiveManager.openBox<NoteItemEntity>(noteCache);
    return noteItemBox;
  }

  saveOrModifyNoteItem(NoteItemEntity noteItemEntity) async {
    noteItemBox = await openNoteBox();
    noteItemBox.put(
      noteItemEntity.id,
      noteItemEntity,
    );
  }

  updateMultipleItems(RxList<Rx<NoteItemEntity>> updateNoteItems) async {
    // 打开Hive盒子
    noteItemBox = await openNoteBox();
    for (final item in updateNoteItems) {
      final index = noteItemBox.values
          .toList()
          .indexWhere((element) => element == item.value);
      if (index != -1) {
        noteItemBox.putAt(index, item.value);
      }
    }
  }

  deleteMultipleItems(RxList<Rx<NoteItemEntity>> noteItems) async {
    noteItemBox = await openNoteBox();
    for (final item in noteItems) {
      final index = noteItemBox.values.toList().indexWhere((element) =>
          element.id == item.value.id && item.value.checked == true);
      if (index != -1) {
        noteItemBox.deleteAt(index);
      }
    }
    noteItems.removeWhere((element) => element.value.checked == true);
    print('allNoteItems after=$noteItems');
  }

  deleteNoteItem(dynamic key) async {
    noteItemBox = await openNoteBox();
    print('noteItemBox=${noteItemBox}');
    noteItemBox.delete(key);
  }

  deleteAllNoteItems() async {
    noteItemBox = await openNoteBox();
    noteItemBox.clear();
  }

  Future<List<Rx<NoteItemEntity>>> getAllNoteItems() async {
    noteItemBox = await openNoteBox();
    final noteItems = noteItemBox.values.map((item) => item.obs).toList();

    ///sort
    noteItems.sort((a, b) {
      final realTimeA = DateTime.parse(a.value.saveTime!);
      final realTimeB = DateTime.parse(b.value.saveTime!);
      return realTimeB.compareTo(realTimeA);
    });
    return noteItems;
  }

  closeNoteBox() {
    HiveManager.closeBox(noteCache);
  }
}
