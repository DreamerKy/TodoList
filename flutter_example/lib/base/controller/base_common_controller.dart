/*
 * @Author: peisen.zhang
 * @Description: 基础逻辑处理类
 */
import '../enum/comment_state.dart';
import 'base_controller.dart';

abstract class BaseCommonController extends BaseController
    with AbstractNetWork {
  BaseCommonController();

  /// 刷新重试事件传递
  @override
  void onRetry() {}
}
