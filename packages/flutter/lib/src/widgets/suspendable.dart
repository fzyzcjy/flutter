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
    super.child,
  });

  @override
  RenderSuspendable createRenderObject(BuildContext context) =>
      RenderSuspendable();

  @override
  void updateRenderObject(
      BuildContext context, RenderSuspendable renderObject) {}
}

///
class RenderSuspendable extends RenderProxyBox {
  ///
  RenderSuspendable({
    RenderBox? child,
  }) : super(child);

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // TODO
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }
}
