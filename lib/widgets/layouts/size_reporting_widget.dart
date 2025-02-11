import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizeReportingWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.onSizeChange,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SizeReportingRenderBox(onSizeChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, SizeReportingRenderBox renderObject) {
    renderObject.onSizeChange = onSizeChange;
  }
}

class SizeReportingRenderBox extends RenderProxyBox {
  SizeReportingRenderBox(this.onSizeChange);

  ValueChanged<Size> onSizeChange;

  @override
  void performLayout() {
    super.performLayout();
    onSizeChange(size);
  }
}
