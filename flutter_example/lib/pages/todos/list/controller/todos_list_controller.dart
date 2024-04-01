import 'package:get/get.dart';
import '../../../../app/repository/note_data_repository.dart';
import '../../../../base/controller/base_common_controller.dart';
import '../../../../entity/note_item_enity.dart';

class TodosListController extends BaseCommonController {
  bool markAllComplete = false;
  RxList<Rx<NoteItemEntity>> rxNoteItems = RxList<Rx<NoteItemEntity>>([]);
  RxBool rxIsChecked = false.obs;
  NoteDataRepository noteDataRepository = NoteDataRepository();

  @override
  void initData() {}

  onChanged(bool? isChecked, Rx<NoteItemEntity> itemEntity) {
    print("isChecked=$isChecked");
    itemEntity.value.checked = isChecked!;
    rxIsChecked.value = isChecked;
    noteDataRepository.insertData(itemEntity);
  }

  /*
   * @method 根据筛选条件查询记事集合
   * @param filterCriteria 筛选条件
   */
  findAllNodeList(String filterCriteria) async {
    await Future.delayed(const Duration(milliseconds: 200));
    //查询全部数据
    List<Rx<NoteItemEntity>> allNoteItems =
        await noteDataRepository.getAllData();
    switch (filterCriteria) {
      case '1':
        // 获取全部数据
        allNoteItems = allNoteItems;
        break;
      case '2':
        // 显示已创建的事件
        allNoteItems =
            noteDataRepository.findListByCondition(allNoteItems.obs, false);
        break;
      case '3':
        // 显示已完成的事件
        allNoteItems =
            noteDataRepository.findListByCondition(allNoteItems.obs, true);
        break;
      case '4':
        //全选/取消全选
        allNoteItems = getSelectChangedDataList(allNoteItems.obs);
        break;
      case '5':
        // 清除数据
        clearAllDatas(allNoteItems.obs);
        break;
      default:
    }
    if (rxNoteItems.isNotEmpty) {
      rxNoteItems.clear();
    }
    rxNoteItems.addAll(allNoteItems);
  }

  getSelectChangedDataList(RxList<Rx<NoteItemEntity>> allNoteItems) {
    print("isAllSelect前=$markAllComplete");
    markAllComplete = !markAllComplete;
    print("isAllSelect后=$markAllComplete");
    for (var itemEntity in allNoteItems) {
      itemEntity.value.checked = markAllComplete;
    }
    noteDataRepository.updateMultipleData(allNoteItems);
    return allNoteItems;
  }

  clearAllDatas(RxList<Rx<NoteItemEntity>> allNoteItems) {
    ///清除列表数据
    if (allNoteItems.isNotEmpty) {
      allNoteItems.clear();
    }
    noteDataRepository.deleteAllData();
    update();
  }

  @override
  void onDestroy() {}
}
