import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
class SuspendableCoordinator {
  SuspendableCoordinator._();

  ///
  static final SuspendableCoordinator instance = SuspendableCoordinator._();

  ///
  bool nearTimeout = false;

// TODO
}

///
class Suspendable extends SingleChildRenderObjectWidget {
  ///
  const Suspendable({
    super.key,
    this.debugName,
    super.child,
  });

  ///
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

///
class RenderSuspendable extends RenderProxyBox {
  ///
  RenderSuspendable({
    RenderBox? child,
    this.debugName,
  }) : super(child);

  ///
  String? debugName;

  bool suspending = false;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    _log('layout');
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  void _log(String message) => debugPrint('[$debugName] $message');
}
