import 'dart:convert';

import 'package:hive/hive.dart';
part 'note_item_enity.g.dart';

/// 记事本item实体类
@HiveType(typeId: 0) // typeId 范围是0-233, 每个模型类的typeId应不同
class NoteItemEntity extends HiveObject {
  @HiveField(0)
  // 唯一id
  String id;
  // 标题
  @HiveField(1)
  String title;
  // 副标题
  @HiveField(2)
  String subTitle;
  // 是否选中
  @HiveField(3)
  bool checked;
  // 保存时间
  @HiveField(4)
  String? saveTime;
  NoteItemEntity(
      {this.id = '',
      this.title = '',
      this.subTitle = '',
      this.checked = false,
      this.saveTime = ''});
  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'checked': checked,
      'saveTime': saveTime,
    });
  }
}
