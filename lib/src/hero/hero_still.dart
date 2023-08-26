import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';
import 'package:hero_animation/src/hero/hero_animation_scene.dart';
import 'package:hero_animation/src/hero/models.dart';

class HeroStill extends StatelessWidget {
  final Scope scope;

  const HeroStill({
    required this.scope,
    Key? key,
  }) : super(key: key);

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
      },
    );
  }
}

class VisibilityControllerAndPositionDetector
    extends SingleChildRenderObjectWidget {
  final HeroAnimationController controller;
  final FlightState? flightState;

  const VisibilityControllerAndPositionDetector({
    required this.controller,
    required this.flightState,
    Key? key,
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
    renderObject.setController(controller);
    renderObject.setFlightState(flightState);
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

  void setController(HeroAnimationController controller) {
    if (_controller != controller) {
      _controller = controller;
      markNeedsPaint();
    }
  }

  void setFlightState(FlightState? flightState) {
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
    final globalOffset = localToGlobal(
      Offset.zero,
      ancestor: findRenderObjectOfType<HeroSceneMarkerRenderObject>(),
    );

    final layoutRect =
        Rect.fromPoints(globalOffset, size.bottomRight(globalOffset));

    _controller.animateIfNeeded(layoutRect, _screenSize);

    final isVisible = !_controller.isFlyVisible;

    final painter = isVisible
        ? super.paint
        : (PaintingContext context, Offset offset) =>
            context.pushOpacity(offset, 0, super.paint);

    context.pushTransform(
      needsCompositing,
      offset,
      Matrix4.identity(),
      painter,
    );
  }
}

extension RenderObjectExtension on RenderBox {
  RenderObject? findRenderObjectOfType<T>() {
    RenderObject? node = this;

    while (node != null) {
      if (node is T) {
        return node;
      }
      node = node.parent as RenderObject?;
    }
    return null;
  }
}
