import 'package:flutter/material.dart';

/// 配置普通网络请求规范
mixin AbstractNetWork {
  /// 刷新重试事件传递
  @protected
  void onRetry();
}
