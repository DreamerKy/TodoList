import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vanilla_example/base/view/base_common_view.dart';
import '../../../../app/constants.dart';
import '../../../../app/router/navigator.dart';
import '../../../../entity/note_item_enity.dart';
import '../../../controller/note_controller.dart';

class NoteDetailPage extends BaseCommonView<NoteController> {
  NoteDetailPage({super.key});
  @override
  bool? get isHiddenNav => false;

  ///标题
  @override
  String? get navTitle => "记事详情";
  @override
  Color? get navTitleColor => Colors.white;
  @override
  Color? get navColor => Colors.black;
  @override
  double? get navTitleSize => 15.sp;
  @override
  Color? get contentColor => const Color(0XFFF4F4F4);
  @override
  bool? get titleCenter => true;
  @override
  Widget? get leftButton => leftBack();
  @override
  List<Widget>? get rightActionList => rightActionWidgets();
  Rx<NoteItemEntity> rxNoteItemEntity =
      Get.arguments == null ? null : Get.arguments[keyItemData];
  @override
  Widget buildContent() {
    return GetBuilder<NoteController>(
      init: NoteController(),
      builder: (controller) => creatCommonView(
        controller,
        noteDetailWidget(controller),
      ),
      assignId: true,
    );
  }

  leftBack() {
    return IconButton(
      onPressed: () {
        NavigatorUtils.goBack(Get.context!);
      },
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }

  List<Widget> rightActionWidgets() {
    return [rightDeleteMenu()];
  }

  rightDeleteMenu() {
    var noteControllerCache = Get.isRegistered<NoteController>();
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
      onPressed: () {
        // 点击搜索图标触发的操作
        if (noteControllerCache) {
          NoteController controller = Get.find();
          controller.deleteMenuFunc(rxNoteItemEntity);
        }
      },
    );
  }

  Widget noteDetailWidget(NoteController controller) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => rxNoteItemEntity.value.title == '' &&
                  rxNoteItemEntity.value.subTitle == ''
              ? const Center(
                  child: Text("No Data"),
                )
              : todoDetailWidget(controller, rxNoteItemEntity)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.editNote(rxNoteItemEntity);
        },
        tooltip: '修改',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.mode_edit),
      ),
    );
  }

  todoDetailWidget(NoteController controller, Rx<NoteItemEntity> itemEntity) {
    return ListTile(
      title: Text(
        itemEntity.value.title,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
      ),
      subtitle: Text(
        itemEntity.value.subTitle,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
      ),
      leading: Checkbox(
        value: itemEntity.value.checked,
        onChanged: (bool? isChecked) =>
            controller.toggleItemChecked(isChecked, itemEntity),
      ),
    );
  }
}
