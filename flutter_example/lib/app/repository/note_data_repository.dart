import 'package:get/get.dart';
import '../../base/network/base_http_request.dart';
import '../../entity/note_item_enity.dart';
import '../constants.dart';
import '../database/note_database_helper.dart';
import 'base/base_repository.dart';

class NoteDataRepository extends BaseRepository<NoteItemEntity> {
  RxString rxMarkAllCompleteTag = '0'.obs;
  bool markAllComplete = false;

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
  Future<RxList<Rx<NoteItemEntity>>> getAllData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    RxList<Rx<NoteItemEntity>> allNoteItems =
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

  setMarkAllComplete(bool markAllComplete) {
    rxMarkAllCompleteTag.value = markAllComplete ? '1' : '0';
  }

  @override
  void updateData(Rx<NoteItemEntity> data) {
    noteDataBaseHelper.saveOrModifyNoteItem(data.value);
  }

  @override
  void deleteAllData() {
    noteDataBaseHelper.deleteAllNoteItems();
  }

  RxList<Rx<NoteItemEntity>> findListByCondition(
      RxList<Rx<NoteItemEntity>> allNoteItems, bool isChecked) {
    final noteItems = allNoteItems
        .where((element) => element.value.checked == isChecked)
        .toList();
    return noteItems.obs;
  }

  @override
  void updateMultipleData(RxList<Rx<NoteItemEntity>> datas) {
    noteDataBaseHelper.updateMultipleItems(datas);
  }

  @override
  Future<RxList<Rx<NoteItemEntity>>?> queryListByFilterStatus(
      String filterOneStatus, String filterTwoStatus) async {
    //查询全部数据
    RxList<Rx<NoteItemEntity>>? allNoteItems = await getAllData();
    switch (filterOneStatus) {
      case filterAll:
        // 获取全部数据
        allNoteItems = allNoteItems;
        break;
      case filterActive:
        // 显示已创建的事件
        allNoteItems = findListByCondition(allNoteItems, false);
        break;
      case filterCompleted:
        // 显示已完成的事件
        allNoteItems = findListByCondition(allNoteItems, true);
        break;
    }
    switch (filterTwoStatus) {
      case filterMark:
        //标记全部完成/标记全部待办
        allNoteItems = getSelectChangedDataList(allNoteItems);
        break;
      case filterClearCompleted:
        // 清除完成数据
        clearFinishedDatas(allNoteItems);
        break;
    }
    return allNoteItems;
  }

  RxList<Rx<NoteItemEntity>> getSelectChangedDataList(
      RxList<Rx<NoteItemEntity>> allNoteItems) {
    ///勾选列表某一项时不执行全选/取消逻辑
    print("isAllSelect前=$markAllComplete");
    markAllComplete = !markAllComplete;
    print("isAllSelect后=$markAllComplete");
    for (var itemEntity in allNoteItems) {
      itemEntity.value.checked = markAllComplete;
    }
    updateMultipleData(allNoteItems);
    setMarkAllComplete(markAllComplete);
    return allNoteItems;
  }

  clearFinishedDatas(RxList<Rx<NoteItemEntity>> allNoteItems) {
    ///清除列表已完成事件数据
    print('allNoteItems berfore=$allNoteItems');
    noteDataBaseHelper.deleteMultipleItems(allNoteItems);
  }

  Future<int> calCountByCondition(bool isChecked) async {
    RxList<Rx<NoteItemEntity>>? allNoteItems = await getAllData();
    final dataList = allNoteItems
        .where((element) => element.value.checked == isChecked)
        .toList();
    return dataList.isNotEmpty ? dataList.length : 0;
  }
}
