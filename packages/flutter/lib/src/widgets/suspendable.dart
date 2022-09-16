// ignore_for_file: public_member_api_docs, always_specify_types, flutter_style_todos, depend_on_referenced_packages

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

abstract class SuspendableTimeSource {
  bool hasRemainTime();
}

class SuspendableTimeSourcePseudo implements SuspendableTimeSource {
  int pseudoRemainTime = 0;

  @override
  bool hasRemainTime() {
    debugPrint('SuspendableTimeSourceDebug hasRemainTimeAndDecr '
        '(before)pseudoRemainTime=$pseudoRemainTime');
    return (pseudoRemainTime--) > 0;
  }
}

class SuspendableTimeSourceReal implements SuspendableTimeSource {
  SuspendableTimeSourceReal() {
    // initial hacky impl: this will schedule a new frame...
    SchedulerBinding.instance.scheduleFrameCallback(_handleFrameCallback);
  }

  // initial hacky impl: a bit less than 16.67 ms,
  // such that other tasks can have a bit of time
  static const kTimeLimit = Duration(milliseconds: 12);

  late DateTime _lastStartFrameTime;

  void _handleFrameCallback(Duration _) {
    _lastStartFrameTime = clock.now();
    // debugPrint(
    //     'SuspendableTimeSourceReal _handleFrameCallback set lastStartFrameTime=$_lastStartFrameTime');
    SchedulerBinding.instance.scheduleFrameCallback(_handleFrameCallback);
  }

  @override
  bool hasRemainTime() =>
      clock.now().difference(_lastStartFrameTime) < kTimeLimit;
}

class SuspendableCoordinator {
  SuspendableCoordinator._();

  static final SuspendableCoordinator instance = SuspendableCoordinator._();

  late SuspendableTimeSource timeSource;
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
    final hasRemainTime =
        SuspendableCoordinator.instance.timeSource.hasRemainTime();
    _log('performLayout START hasRemainTime=$hasRemainTime '
        'now=${clock.now()} '
        '(old)suspending=$suspending (old)prevSize=$prevSize');

    if (hasRemainTime) {
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

  void _log(String message) =>
      debugPrint('[$debugName, this=$this, child=$child] $message');
}
