/*
 * @Description: 进度条widget
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingWidget extends StatelessWidget {
  final bool? hidden;
  const LoadingWidget({Key? key, this.hidden}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hidden == true) {
      return Container();
    } else {
      return const Center(
        //保证控件居中效果
        child: CupertinoActivityIndicator(
          radius: 14,
          color: Colors.black38,
        ),
      );
    }
  }
}

class Loading {
  /// 显示普通Toast
  static void toast(String msg) {
    dismiss();
    showToast(msg);
  }

  /// 提示文字
  static void show({
    String? title = "加载中...",
  }) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.none
      ..userInteractions = false
      ..maskColor = Colors.black.withAlpha(1)
      ..indicatorSize = 120
      ..radius = 8.r
      ..fontSize = 14
      ..dismissOnTap = false
      ..boxShadow = [const BoxShadow(color: Colors.transparent)]
      ..contentPadding = const EdgeInsets.only(
          left: 31.25, right: 31.25, top: 31.25, bottom: 29.25)
      ..backgroundColor = Colors.black.withOpacity(0.7)
      // ..indicatorColor = Colors.deepOrangeAccent
      ..textPadding = const EdgeInsets.only(bottom: 14)
      ..textColor = Colors.white;

    EasyLoading.show(
        status: title,
        indicator: const SizedBox(
          height: 23,
          width: 23,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.0,
          ),
        ),
        dismissOnTap: false);
  }

  static void showApprovedToast(
    String msg, {
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    dismiss();

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..boxShadow = [const BoxShadow(color: Colors.transparent)]
      ..userInteractions = true
      ..maskType = EasyLoadingMaskType.black
      ..contentPadding =
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 7.5, bottom: 9.5)
      ..textColor = Colors.black87
      ..successWidget = Image.asset(
        "assets/icons/apply_success_icon.png",
        width: 24.w,
        height: 24.h,
      )
      ..textStyle = TextStyle(fontWeight: FontWeight.bold)
      ..radius = 8.r
      ..maskColor = Colors.black.withAlpha(1)
      ..indicatorColor = Colors.transparent
      ..fontSize = 18.sp
      ..backgroundColor = Colors.white;
    EasyLoading.showSuccess(
      msg,
      dismissOnTap: false,
    );
  }

  static void showToast(
    String msg, {
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    dismiss();

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..boxShadow = [const BoxShadow(color: Colors.transparent)]
      ..userInteractions = true
      ..maskType = EasyLoadingMaskType.none
      ..contentPadding =
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 7.5, bottom: 9.5)
      ..textColor = Colors.white
      ..radius = 8.r
      ..fontSize = 14.0
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.deepOrangeAccent
      ..textColor = Colors.white;
    // ..maskColor = Colors.black.withAlpha(100);

    EasyLoading.showToast(
      msg,
      toastPosition: EasyLoadingToastPosition.center,
      dismissOnTap: false,
    );
  }

  /// 显示成功Toast
  static void showSuccess(
    String msg, {
    Duration? duration = const Duration(seconds: 3),
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    if (msg != '') {
      dismiss();
      showToast(msg, maskType: maskType, dismissOnTap: dismissOnTap);
    }
  }

  static void showError(
    String msg, {
    Duration? duration = const Duration(seconds: 3),
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    if (msg != '') {
      dismiss();
      showToast(msg, maskType: maskType, dismissOnTap: dismissOnTap);
    }
  }

  static void showInfo(
    String msg, {
    Duration? duration = const Duration(seconds: 3),
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    dismiss();
    showToast(msg, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  /// 取消Toast
  static void dismiss() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
  }

  /// 显示loding
  /// BuildContext context
  /// msg: 显示内容
  /// userInteraction: 是否允许交互
  /// type: 样式
  /// isRealTime: 是否立即显示 ture立即显示 false 是延迟加载的 注意:在initState中方法调用必须为false 不然会出问题
  static void showLoading(double value,
      {String msg = "", EasyLoadingMaskType? easyLoadingMaskType}) {
    dismiss();
    EasyLoading.showProgress(value, status: msg, maskType: easyLoadingMaskType);
  }

  static void dissmiss() {
    EasyLoading.dismiss();
  }
}
