// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants.dart';
import '../../../../app/router/navigator.dart';
import '../../../../app/router/router_config.dart';
import '../../../../base/view/base_common_view.dart';
import '../../../../entity/note_item_enity.dart';
import '../../../controller/note_controller.dart';

class TodosListPage extends BaseCommonView<NoteController> {
  TodosListPage({
    Key? key,
  });
  @override
  bool? get isHiddenNav => true;

  @override
  Widget buildContent() {
    return GetBuilder<NoteController>(
      init: NoteController(),
      builder: (controller) => creatCommonView(
        controller,
        todosContentWidget(controller),
      ),
      assignId: true,
    );
  }

  todosContentWidget(NoteController controller) {
    controller.queryListByFilterStatus(
        controller.rxFilterOneStatus.value, controller.rxFilterTwoStatus.value);
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      // 允许高度自适应
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Obx(() => controller.rxNoteItems.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : todoListWidget(controller, controller.rxNoteItems)),
    );
  }

  todoListWidget(
      NoteController controller, RxList<Rx<NoteItemEntity>> allNoteItems) {
    print('rxNoteItems todoListWidget=$allNoteItems');
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        Rx<NoteItemEntity> noteItemEntity = allNoteItems[index];
        return todoListItemWidget(
            controller, noteItemEntity, index, allNoteItems);
      },
      itemCount: allNoteItems.length,
    );
  }

  todoListItemWidget(NoteController controller, Rx<NoteItemEntity> rxItemEntity,
      int index, RxList<Rx<NoteItemEntity>> allNoteItems) {
    return Obx(
      () => ListTile(
        title: Text(
          rxItemEntity.value.title,
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
        ),
        subtitle: Text(
          rxItemEntity.value.subTitle,
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
        ),
        leading: Checkbox(
          value: rxItemEntity.value.checked,
          onChanged: (bool? isChecked) =>
              controller.toggleItemChecked(isChecked, rxItemEntity),
        ),
        onTap: () {
          NavigatorUtils.pushByName(
            RoutesConfig.notedetail,
            arguments: {keyItemData: rxItemEntity},
            resultFunc: (result) =>
                controller.backResultFunc(result, rxItemEntity, allNoteItems),
          );
        },
      ),
    );
  }
}
