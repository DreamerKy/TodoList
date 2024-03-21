import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigatorUtils {
  static pushByName(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Function(dynamic)? resultFunc,
  }) {
    Get.toNamed(page,
            arguments: arguments,
            id: id,
            preventDuplicates: preventDuplicates,
            parameters: parameters)
        ?.then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      if (resultFunc != null) resultFunc(result);
    }).catchError((error) {});
  }

  static offAllByName(
    String newRouteName, {
    RoutePredicate? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
    Function(Object)? resultFunc,
  }) {
    Get.offAllNamed(newRouteName,
            arguments: arguments,
            id: id,
            predicate: predicate,
            parameters: parameters)
        ?.then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      if (resultFunc != null) resultFunc(result);
    }).catchError((error) {});
  }

  /// 返回
  static void goBack(BuildContext context, {result}) {
    if (result != null) {
      Get.back(result: result);
    } else {
      Get.back();
    }
  }
}
