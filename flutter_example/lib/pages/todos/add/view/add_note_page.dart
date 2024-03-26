import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/constants.dart';
import '../../../../app/router/navigator.dart';
import '../../../../base/view/base_common_view.dart';
import '../../../controller/note_controller.dart';

class AddToNotePage extends BaseCommonView<NoteController> {
  AddToNotePage({super.key});
  @override
  bool? get isHiddenNav => false;

  ///标题
  @override
  String? get navTitle => "添加记事本";
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
  Widget buildContent() {
    return GetBuilder<NoteController>(
      init: NoteController(),
      builder: (controller) => creatCommonView(
        controller,
        addNoteWidget(controller),
      ),
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

  Widget addNoteWidget(NoteController controller) {
    String? title = Get.arguments == null ? '' : Get.arguments[keyTitle];
    String? subTitle = Get.arguments == null ? '' : Get.arguments[keySubTitle];
    String isEdit = Get.arguments == null ? '' : Get.arguments[keyIsEdit];
    controller.titleController.text = title ?? '';
    controller.contentController.text = subTitle ?? '';
    controller.setEditMode(isEdit);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: controller.titleController,
                focusNode: controller.titleNodeText,
                decoration: const InputDecoration(hintText: "需要做些什么"),
              ),
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  controller: controller.contentController,
                  focusNode: controller.contentNodeText,
                  decoration: const InputDecoration(hintText: "事件详情"),
                  maxLength: 2000,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.motifyOrSave();
        },
        tooltip: '完成',
        child: const Icon(Icons.done),
      ),
    );
  }
}
