import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'hero_animation_controller.dart';
import 'hero_animation_scene.dart';
import 'models.dart';

class HeroStill extends StatelessWidget {
  final Scope scope;

  const HeroStill({required this.scope, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FlightState>(
        valueListenable: scope.controller.flightState,
        builder: (context, flightState, child) {
          final heroAnimation = scope.widget;

          return VisibilityControllerAndPositionDetector(
            controller: scope.controller,
            flightState: flightState,
            child: heroAnimation.heroBuilder != null
                ? heroAnimation.heroBuilder!.call(context, flightState, child)
                : heroAnimation.child,
          );
        });
  }
}

class VisibilityControllerAndPositionDetector
    extends SingleChildRenderObjectWidget {
  final HeroAnimationController controller;
  final FlightState? flightState;

  const VisibilityControllerAndPositionDetector({
    Key? key,
    required this.controller,
    required this.flightState,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  HeroStillRenderObject createRenderObject(BuildContext context) {
    return HeroStillRenderObject(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    HeroStillRenderObject renderObject,
  ) {
    renderObject.controller = controller;
    renderObject.flightState = flightState;
  }
}

class HeroStillRenderObject extends RenderProxyBox {
  late HeroAnimationController _controller;
  FlightState? _flightState;

  HeroStillRenderObject({
    required HeroAnimationController controller,
    RenderBox? child,
  }) : super(child) {
    _controller = controller;
  }

  set controller(HeroAnimationController controller) {
    if (_controller != controller) {
      _controller = controller;
      markNeedsPaint();
    }
  }

  set flightState(FlightState? flightState) {
    if (flightState != null && flightState != _flightState) {
      _flightState = flightState;
      markNeedsPaint();
    }
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    return !_controller.isFlyVisible &&
        super.hitTest(result, position: position!);
  }

  Size get _screenSize => (owner?.rootNode as RenderView).size;

  @override
  void paint(PaintingContext context, Offset offset) {
    final globalOffset = globalPosition();

    final layoutRect =
        Rect.fromPoints(globalOffset, size.bottomRight(globalOffset));

    _controller.animateIfNeeded(layoutRect, _screenSize);

    final isVisible = !_controller.isFlyVisible;

    final painter = isVisible
        ? super.paint
        : (PaintingContext context, Offset offset) =>
            context.pushOpacity(offset, 0, super.paint);

    context.pushTransform(
        needsCompositing, offset, Matrix4.identity(), painter);
  }
}

extension RenderObjectExtension on RenderBox {
  Offset globalPosition() {
    AbstractNode? node = this;

    while (node != null) {
      if (node is HeroSceneMarkerRenderObject) {
        return localToGlobal(Offset.zero, ancestor: node);
      }
      node = node.parent as RenderObject?;
    }
    return Offset.zero;
  }
}
