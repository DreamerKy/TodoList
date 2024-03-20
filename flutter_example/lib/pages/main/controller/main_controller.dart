import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import '../../../app/constants.dart';
import '../../../base/controller/base_common_controller.dart';

///main tab controller
class MainController extends BaseCommonController {
  PageController pageController = PageController();
  int currentIndex = 0;
  String curValue = '1';
  String markAllCompleteTag = "0";

  menuValueChanged(dynamic value) {
    if (value == '4') {
      SpUtil.putString(keySelectMenu, valueSelectMenu);
    } else if (value == '5') {
      SpUtil.putString(keyClearMenu, valueClearMenu);
    }
    curValue = value;
    update();
    print("值改变了：$curValue");
  }

  @override
  void initData() {}

  @override
  void onDestroy() {}
}
