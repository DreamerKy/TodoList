import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum EmptyStatusType {
  fail, // 请求失败，网络异常
  noMessage, // 无数据
}

///数据为空的空页面
class EmptyStatusWidget extends StatefulWidget {
  final String? message;
  final String? refreshTitle;
  final Color? bgColor;
  final Function()? onTap;
  final EmptyStatusType emptyType;
  final double? paddingTop;
  final double? width;
  final double? height;
  const EmptyStatusWidget({
    Key? key,
    this.message,
    this.refreshTitle,
    this.bgColor,
    this.onTap,
    this.paddingTop,
    required this.emptyType,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<EmptyStatusWidget> createState() => _EmptyStatusWidgetState();
}

class _EmptyStatusWidgetState extends State<EmptyStatusWidget> {
  /// 间隙
  Widget _gap({double? height, double? width}) =>
      SizedBox(height: height ?? 0, width: width ?? 0);

  /// 标题
  Widget _title() {
    TextStyle style =
        TextStyle(fontSize: 14.sp, color: const Color(0xFF999999));
    return Text(_getTitleString(), style: style);
  }

  String _getTitleString() {
    if (widget.message != null) {
      return widget.message!;
    } else if (widget.emptyType == EmptyStatusType.fail) {
      return '暂无网络，请检查网络';
    } else {
      return '暂无数据';
    }
  }

  /// 图片
  Widget _image() {
    return SizedBox(
      width: 160.w,
      height: 160.w,
      child: _getImageWidget(),
    );
  }

  /// 获取图片名称
  Widget _getImageWidget() {
    if (widget.emptyType == EmptyStatusType.fail) {
      return Image.asset('assets/icons/icon_h5_neterror.png');
    } else {
      return Image.asset('assets/icons/ic_empty.png');
    }
  }

  /// 刷新按钮
  Widget _refreshButton() {
    if (widget.refreshTitle != null && widget.refreshTitle!.isNotEmpty) {
      TextStyle style =
          TextStyle(fontSize: 16.sp, color: const Color(0xFFFFFFFF));
      Decoration decoration = BoxDecoration(
        color: const Color(0xFF102FA5),
        borderRadius: BorderRadius.circular(19.r),
      );
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 96.w,
          height: 38.h,
          decoration: decoration,
          margin: EdgeInsets.only(top: 18.h),
          alignment: Alignment.center,
          child: Text(widget.refreshTitle!, style: style),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap,
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height,
        color: widget.bgColor ?? Colors.white,
        padding: EdgeInsets.only(top: widget.paddingTop ?? 194.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _image(),
            _title(),
            _refreshButton(),
          ],
        ),
      ),
    );
  }
}
