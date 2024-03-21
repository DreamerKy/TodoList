import 'package:get/get.dart';
import '../enum/page_state.dart';

abstract class BaseController extends GetxController {
  /// 定义网络状态方便子控制器使用
  PageState netState = PageState.initializeState;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    onDestroy();
    super.dispose();
  }

  void initData();
  void onDestroy();
}
