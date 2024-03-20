import 'package:flutter/widgets.dart';

class FhKeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const FhKeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<FhKeepAliveWrapper> createState() => _FhKeepAliveWrapperState();
}

class _FhKeepAliveWrapperState extends State<FhKeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
