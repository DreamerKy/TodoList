import 'package:sp_util/sp_util.dart';

import '../constants.dart';

class MarkStatusUtil {
  // 保存标记全部状态
  static setMarkALLComplete(bool isMarkAll) {
    SpUtil.putBool(isMarkAllComple, isMarkAll);
  }

  // 获取标记全部状态
  static bool isMarkALLComplete() {
    return SpUtil.getBool(isMarkAllComple) ?? false;
  }
}
