import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtil {
  static showSnackBar(
    String title,
    String message,
  ) {
    configSnackBar(title, message,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3));
  }

  static configSnackBar(
    String title,
    String message, {
    Color? colorText,
    Color? backgroundColor,
    Duration? duration,
    SnackPosition? snackPosition,
    OnTap? onTap,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Widget? childWidget,
    VoidCallback? onPressed,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      backgroundColor: backgroundColor,
      duration: duration,
      snackPosition: snackPosition,
      margin: margin,
      isDismissible: true,
      padding: padding,
      snackStyle: SnackStyle.FLOATING,
      mainButton: TextButton(
        onPressed: onPressed,
        child: childWidget ?? Container(),
      ),
    );
  }
}
