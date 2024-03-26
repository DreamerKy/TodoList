import '../../entity/menu_item_entity.dart';
import '../constants.dart';

List<MenuItemEntity> createSelectFuncDataList() {
  return [
    MenuItemEntity(label: "显示全部事项", value: filterAll),
    MenuItemEntity(label: "显示待办事项", value: filterActive),
    MenuItemEntity(label: "显示完成事项", value: filterCompleted),
  ];
}

/// markAllCompleteTag "0" :标记全部完成;"1":标记全部待办 -1:其他
List<MenuItemEntity> createFilterDataList(String markAllCompleteTag) {
  return [
    MenuItemEntity(
        label: markAllCompleteTag == '0' ? "标记全部完成" : "标记全部待办",
        value: filterMark),
    MenuItemEntity(label: "清除完成数据", value: filterClearCompleted),
  ];
}
