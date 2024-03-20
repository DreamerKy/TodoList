/// 通用菜单项实体类
class MenuItemEntity {
  // 显示的文本
  String label;
  // 选中的值
  dynamic value;
  // 是否选中
  bool checked;

  MenuItemEntity({this.label = '', this.value, this.checked = false});
}
