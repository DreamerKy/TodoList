import 'package:flutter/material.dart';

import '../../entity/menu_item_entity.dart';

/// 弹出菜单按钮组件
class SelectWidget extends StatefulWidget {
  final List<MenuItemEntity> items; // 显示的内容
  final dynamic value; // 当前选中的值
  final String? title; // 选择框前的标题
  final String tooltip; // 提示语
  final bool showTitle; // showTitle ?  带标题类型的菜单:无标题类型的菜单。
  final ValueChanged<dynamic>? valueChanged; // 选中数据的回调事件
  const SelectWidget(
      {Key? key,
      this.items = const [],
      this.value,
      this.valueChanged,
      this.title,
      this.tooltip = "点击选择",
      required this.showTitle})
      : super(key: key);

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  String label = '请选择';
  bool isExpand = false; // 是否展开下拉按钮
  dynamic currentValue; // 此时的值

  @override
  void initState() {
    currentValue = widget.value;
    super.initState();
  }

  /// 根据当前的value处理当前文本显示
  void initTitle() {
    if (currentValue != null) {
      // 有值查值
      for (MenuItemEntity item in widget.items) {
        if (item.value == currentValue) {
          label = item.label;
          break;
        }
      }
    } else {
      // 没值默认取第一个
      if (widget.items.isNotEmpty) {
        label = widget.items[0].label;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initTitle();
    return Wrap(
      children: [
        if (widget.title != null)
          Text(widget.title!,
              style: const TextStyle(fontSize: 15, color: Colors.white)),
        PopupMenuButton<String>(
          initialValue: currentValue,
          color: Theme.of(context).colorScheme.inverseSurface,
          tooltip: widget.tooltip,
          offset: const Offset(10, 35),
          enableFeedback: true,
          child: Listener(
            // 使用listener事件能够继续传递
            onPointerDown: (event) {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: widget.showTitle
                ? Wrap(
                    children: [
                      Text(
                        label,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      isExpand
                          ? const Icon(Icons.arrow_drop_up, color: Colors.white)
                          : const Icon(Icons.arrow_drop_down,
                              color: Colors.white)
                    ],
                  )
                : const Icon(Icons.more_vert, color: Colors.white),
          ),
          onSelected: (value) {
            widget.valueChanged?.call(value);
            setState(() {
              currentValue = value;
              isExpand = !isExpand;
            });
          },
          onCanceled: () {
            // 取消展开
            setState(() {
              isExpand = false;
            });
          },
          itemBuilder: (context) {
            return widget.items
                .map(
                  (item) => item.value == currentValue
                      ? PopupMenuItem<String>(
                          value: item.value,
                          child: Text(
                            item.label,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        )
                      : PopupMenuItem<String>(
                          value: item.value,
                          child: Text(
                            item.label,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                )
                .toList();
          },
        )
      ],
    );
  }
}
