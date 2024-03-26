import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/mock/menu_data_helper.dart';
import '../../../app/router/navigator.dart';
import '../../../app/router/router_config.dart';
import '../../../base/view/base_common_view.dart';
import '../../../base/widget/fh_keepalive_wrapper.dart';
import '../../../base/widget/select_widget.dart';
import '../../controller/note_controller.dart';
import '../../status/view/status_page.dart';
import '../../todos/list/view/todos_list_page.dart';

// ignore: must_be_immutable
class MainPage extends BaseCommonView<NoteController> {
  MainPage({super.key});
  @override
  bool? get isHiddenNav => true;

  @override
  Widget buildContent() {
    return GetBuilder<NoteController>(
      init: NoteController(),
      builder: (controller) => mainTabWidget(controller),
    );
  }

  Widget mainTabWidget(NoteController controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "记事本",
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
        backgroundColor: Colors.black,
        actions: [
          createFilteMenuOneWidget(),
          const SizedBox(
            width: 15,
          ),
          createFilteMenuTwoWidget(controller),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          FhKeepAliveWrapper(
            child: TodosListPage(),
          ),
          FhKeepAliveWrapper(child: StatusPage()),
        ],
        onPageChanged: (value) {
          controller.currentIndex.value = value;
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            selectedFontSize: 12,
            backgroundColor: Theme.of(Get.context!).colorScheme.inverseSurface,
            unselectedFontSize: 12,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.white,
            currentIndex: controller.currentIndex.value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book,
                  color: Colors.white70,
                  size: 26,
                ),
                activeIcon: Icon(
                  Icons.menu_book,
                  color: Colors.blueAccent,
                  size: 26,
                ),
                label: '记事列表',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.query_stats,
                  color: Colors.white70,
                  size: 26,
                ),
                activeIcon: Icon(
                  Icons.query_stats,
                  color: Colors.blueAccent,
                  size: 26,
                ),
                label: '统计',
              ),
            ],
            onTap: (value) {
              controller.currentIndex.value = value;
              controller.pageController.jumpToPage(value);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigatorUtils.pushByName(RoutesConfig.addnote);
        },
        backgroundColor: Colors.blue,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget createFilteMenuOneWidget() {
    return Obx(
      () => controller.currentIndex.value == 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FhKeepAliveWrapper(
                  child: SelectWidget(
                    items: createSelectFuncDataList(),
                    value: controller.rxFilterOneStatus.value,
                    valueChanged: (value) {
                      controller.menuValueOneChanged(value);
                    },
                    showTitle: true,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Widget createFilteMenuTwoWidget(NoteController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FhKeepAliveWrapper(
          child: Obx(
            () => SelectWidget(
              items: createFilterDataList(
                  controller.noteDataRepository.rxMarkAllCompleteTag.value),
              value: controller.rxFilterTwoStatus.value,
              valueChanged: (value) {
                controller.menuValueTwoChanged(value);
              },
              showTitle: false,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
