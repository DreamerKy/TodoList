// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

/// @Author: peisen.zhang
///App所有页面的基类
abstract class BaseView<T> extends GetView<T> {
  BaseView({Key? key}) : super(key: key);

  /// 状态栏高度
  double statusBarH = ScreenUtil().statusBarHeight;

  /// 导航栏高度
  double navBarH = AppBar().preferredSize.height;

  /// 安全区域高度
  double safeBarH = ScreenUtil().bottomBarHeight;

  /// 设置背景颜色
  Color? contentColor;

  /// 设置标题文字
  String? navTitle;

  /// 设置标题文字颜色
  Color? navTitleColor;

  /// 设置标题文字字体大小
  double? navTitleSize;

  /// 设置标题文字字体样式
  FontWeight? navTitleFontWeight;

  /// 设置标题是否居中
  bool? titleCenter;
  bool? resizeToAvoid;

  /// 设置导航栏颜色
  Color? navColor;

  /// 设置左边按钮
  Widget? leftButton;

  /// 设置左边宽度
  double? leftWidth;

  double? toolbHeight;

  /// 设置右边按钮数组
  List<Widget>? rightActionList;

  /// 是否隐藏导航栏
  bool? isHiddenNav;

  /// 设置主主视图内容(子类不实现会报错)
  Widget buildContent();

  double keyHeight = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoid ?? true,
      backgroundColor: contentColor ?? Colors.white,
      appBar: isHiddenNav == true
          ? null
          : AppBar(
              toolbarHeight: toolbHeight ?? 44.h,
              automaticallyImplyLeading: false,
              backgroundColor: navColor ?? Colors.white,
              centerTitle: titleCenter ?? true,
              title: Text(
                navTitle ?? '',
                style: TextStyle(
                    color: navTitleColor ?? Colors.black,
                    fontSize: navTitleSize ?? 18.sp,
                    fontWeight: navTitleFontWeight),
              ),
              leading: leftButton ?? const SizedBox(),
              leadingWidth: leftWidth ?? 46,
              elevation: 0,
              actions: rightActionList ?? [],
            ),
      body: buildContent(),
      // floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {},
      child: const Icon(Icons.favorite),
    );
  }

  static KeyBoardOnTouchDownWidget(BuildContext context,
      {required Widget child}) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
