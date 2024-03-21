import '../../entity/menu_item_entity.dart';

List<MenuItemEntity> createSelectFuncDataList() {
  return [
    MenuItemEntity(label: "显示全部事项", value: '1'),
    MenuItemEntity(label: "显示待办事项", value: '2'),
    MenuItemEntity(label: "显示完成事项", value: '3'),
  ];
}

/// markAllCompleteTag "0" :标记全部完成;"1":标记全部待办 -1:其他
List<MenuItemEntity> createFilterDataList(String markAllCompleteTag) {
  return [
    MenuItemEntity(
        label: markAllCompleteTag == '0' ? "标记全部完成" : "标记全部待办", value: '4'),
    MenuItemEntity(label: "清除完成数据", value: '5'),
  ];
}
