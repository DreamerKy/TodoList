import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/view/base_common_view.dart';
import '../../controller/note_controller.dart';

class StatusPage extends BaseCommonView<NoteController> {
  StatusPage({super.key});
  @override
  bool? get isHiddenNav => true;
  @override
  Widget buildContent() {
    return GetBuilder<NoteController>(
      init: NoteController(),
      builder: (controller) => creatCommonView(
        controller,
        statusWidget(controller),
      ),
      assignId: true,
    );
  }

  Widget statusWidget(NoteController controller) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              '完成事项统计:${controller.rxFinishNumber.value}',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Text(
              '待办事项统计:${controller.rxActiveNumber.value}',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
