// ignore_for_file: always_specify_types, no_runtimetype_tostring, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hello', (tester) async {
    debugPrintBeginFrameBanner = debugPrintEndFrameBanner = true;

    print('tester.pumpWidget');
    await tester.pumpWidget(const Hello());

    print('tester.pump');
    await tester.pump();

    debugPrintBeginFrameBanner = debugPrintEndFrameBanner = false;
  });
}

class Hello extends SingleChildRenderObjectWidget {
  const Hello({
    super.key,
    super.child,
  });

  @override
  RenderHello createRenderObject(BuildContext context) {
    return RenderHello();
  }

  @override
  void updateRenderObject(BuildContext context, RenderPadding renderObject) {}
}

class RenderHello extends RenderProxyBox {
  RenderHello({
    RenderBox? child,
  }) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    print('$runtimeType paint');
    super.paint(context, offset);

    // hack, just want to repaint in the next frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print('$runtimeType hacky markNeedsPaint');
      markNeedsPaint();
    });
  }
}
