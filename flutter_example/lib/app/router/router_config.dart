import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/todos/add/bindings/add_note_bindings.dart';
import '../../pages/todos/add/view/add_note_page.dart';
import '../../pages/main/bindings/main_bindings.dart';
import '../../pages/main/view/main_page.dart';
import '../../pages/todos/detail/bindings/note_detail_bindings.dart';
import '../../pages/todos/detail/view/note_detail_page.dart';

class RoutesConfig {
  RoutesConfig._();

  ///Tab主页面
  static const main = "/pages/main/";

  ///添加或编辑页面
  static const addnote = "/pages/todos/add";

  ///详情页面
  static const notedetail = "/pages/todos/detail";

  /// 页面合集
  static List<GetPage> routePageList = [
    GetPage(
      name: main,
      page: () => MainPage(),
      binding: MainBindings(),
    ),
    GetPage(
      name: addnote,
      page: () => AddToNotePage(),
      binding: AddNoteBindings(),
    ),
    GetPage(
      name: notedetail,
      page: () => NoteDetailPage(),
      binding: NoteDetailBindings(),
    ),
  ];

  static String? curRoute(BuildContext context) {
    return RoutesConfig.main;
  }
}
