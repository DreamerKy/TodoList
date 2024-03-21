// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/base_common_controller.dart';
import '../enum/page_state.dart';
import '../widget/empty_status.dart';
import '../widget/loading_widget.dart';
import 'base_view.dart';

/// @Author: peisen.zhang
///App公共页面状态的基类
abstract class BaseCommonView<T> extends BaseView<T> {
  BaseCommonView({Key? key}) : super(key: key);

  /// 创建空视图 (子视图实现的话 Widget就是子视图实现的)
  Widget creatEmptyWidget() {
    return const EmptyStatusWidget(
      emptyType: EmptyStatusType.noMessage,
    );
  }

  /// 创建错误视图 (子视图实现的话 Widget就是子视图实现的)
  Widget creatFailWidget(BaseCommonController controller) {
    return EmptyStatusWidget(
      emptyType: EmptyStatusType.fail,
      refreshTitle: '重新加载',
      width: 1.sw,
      height: 1.sh,
      onTap: () {
        /// 重新请求数据
        controller.onRetry();
      },
    );
  }

  /// 创建页面主视图
  Widget creatCommonView(BaseCommonController controller, Widget commonView) {
    return _refresherListView(controller, commonView);
  }

  Widget _refresherListView(
      BaseCommonController controller, Widget commonView) {
    if (controller.netState == PageState.loadingState) {
      /// loading 不会有这个状态,只是写一个这样的判断吧(控制器里面已经封装好了单例了,防止在网络层直接操作控制不了loading的场景)
      return const LoadingWidget();
    } else if (controller.netState == PageState.emptyDataState) {
      /// 返回站位视图
      return creatEmptyWidget();
    } else if (controller.netState == PageState.errorshowRelesh) {
      /// 返回站位刷新视图
      return creatFailWidget(controller);
    } else if (controller.netState == PageState.dataSussessState) {
      return commonView;
    } else if (controller.netState == PageState.initializeState) {
      return commonView;
    } else {
      return commonView;
    }
  }
}
