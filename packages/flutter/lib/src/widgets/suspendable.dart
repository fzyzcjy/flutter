// ignore_for_file: public_member_api_docs, always_specify_types, flutter_style_todos

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class SuspendableCoordinator {
  SuspendableCoordinator._();

  static final SuspendableCoordinator instance = SuspendableCoordinator._();

  int pseudoRemainTime = 0;

  bool hasPseudoRemainTimeAndDecr() {
    debugPrint('SuspendableCoordinator hasPseudoRemainTimeAndDecr '
        '(before)pseudoRemainTime=$pseudoRemainTime');
    return (pseudoRemainTime--) > 0;
  }
}

class Suspendable extends SingleChildRenderObjectWidget {
  const Suspendable({
    super.key,
    this.debugName,
    super.child,
  });

  final String? debugName;

  @override
  RenderSuspendable createRenderObject(BuildContext context) =>
      RenderSuspendable(
        debugName: debugName,
      );

  @override
  void updateRenderObject(
      BuildContext context, RenderSuspendable renderObject) {
    renderObject.debugName = debugName;
  }
}

class RenderSuspendable extends RenderProxyBox {
  RenderSuspendable({
    RenderBox? child,
    this.debugName,
  }) : super(child);

  String? debugName;

  bool suspending = false;
  Size? prevSize;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    _log('layout START');
    super.layout(constraints, parentUsesSize: parentUsesSize);
    _log('layout END');
  }

  @override
  void performLayout() {
    final hasPseudoRemainTime =
        SuspendableCoordinator.instance.hasPseudoRemainTimeAndDecr();
    _log('performLayout START hasPseudoRemainTime=$hasPseudoRemainTime '
        '(old)suspending=$suspending (old)prevSize=$prevSize');

    if (hasPseudoRemainTime) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;

      prevSize = size;
      suspending = false;
    } else {
      size = prevSize ?? Size.zero;

      suspending = true;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _log('performLayout.PostFrameCallback markNeedsLayout');
        markNeedsLayout();
      });
    }

    _log('performLayout END');
  }

  // ref: [RenderOpacity], it can choose not to paint child at all
  @override
  bool paintsChild(RenderBox child) {
    assert(child.parent == this);
    return !suspending;
  }

  // ref: [RenderOpacity], it can choose not to paint child at all
  @override
  void paint(PaintingContext context, Offset offset) {
    _log('paint suspending=$suspending');

    if (suspending) {
      // TODO: paint using `toImageSync`, instead of painting nothing
    } else {
      context.paintChild(child!, offset);
    }
  }

  void _log(String message) => debugPrint('[$debugName, this=$this, child=$child] $message');
}
