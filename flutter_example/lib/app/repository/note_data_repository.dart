import 'package:get/get.dart';
import '../../base/network/base_http_request.dart';
import '../../entity/note_item_enity.dart';
import '../constants.dart';
import '../database/note_database_helper.dart';
import 'base/base_repository.dart';

class NoteDataRepository extends BaseRepository<NoteItemEntity> {
  @override
  Future<RxList<Rx<NoteItemEntity>>> fetchData(String url) async {
    RxList<Rx<NoteItemEntity>> noteItems = RxList<Rx<NoteItemEntity>>([]);
    BaseHttpRequest.request(
      url,
      method: 'get',
      successCallback: (json) {
        noteItems = parseResponse(json);
      },
      failureCallback: (errCode, errMsg) {},
      netWorkError: (e) {
        handleError(e);
      },
    );
    return noteItems;
  }

  @override
  Future<List<Rx<NoteItemEntity>>> getAllData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    List<Rx<NoteItemEntity>> allNoteItems =
        await noteDataBaseHelper.getAllNoteItems();
    return allNoteItems;
  }

  @override
  void handleError(error) {
    print('error=$error');
  }

  @override
  void insertData(Rx<NoteItemEntity> data) {
    noteDataBaseHelper.saveOrModifyNoteItem(data.value);
  }

  @override
  void deleteData(dynamic key) async {
    noteDataBaseHelper.deleteNoteItem(key);
  }

  @override
  RxList<Rx<NoteItemEntity>> parseResponse(data) {
    RxList<Rx<NoteItemEntity>> allNoteItems = RxList<Rx<NoteItemEntity>>();
    return allNoteItems;
  }

  @override
  void updateData(Rx<NoteItemEntity> data) {
    noteDataBaseHelper.saveOrModifyNoteItem(data.value);
  }

  @override
  void deleteAllData() {
    noteDataBaseHelper.deleteAllNoteItems();
  }

  List<Rx<NoteItemEntity>> findListByCondition(
      RxList<Rx<NoteItemEntity>> allNoteItems, bool isChecked) {
    final noteItems = allNoteItems
        .where((element) => element.value.checked == isChecked)
        .toList();
    return noteItems;
  }

  @override
  void updateMultipleData(RxList<Rx<NoteItemEntity>> datas) {
    noteDataBaseHelper.updateMultipleItems(datas);
  }

  clearFinishedDatas(RxList<Rx<NoteItemEntity>> allNoteItems) {
    ///清除列表已完成事件数据
    print('allNoteItems berfore=$allNoteItems');
    noteDataBaseHelper.deleteMultipleItems(allNoteItems);
  }

  Future<int> calCountByCondition(bool isChecked) async {
    List<Rx<NoteItemEntity>> findNoteItems = await getAllData();
    final dataList = findNoteItems
        .where((element) => element.value.checked == isChecked)
        .toList();
    return dataList.isNotEmpty ? dataList.length : 0;
  }
}
