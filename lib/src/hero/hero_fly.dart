import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';
import 'package:hero_animation/src/hero/hero_animation_scene.dart';
import 'package:hero_animation/src/hero/models.dart';

class HeroFly extends StatelessWidget {
  final Scope scope;

  const HeroFly({required this.scope, required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Event>(
      valueListenable: scope.controller.layoutRectAndFlightState,
      builder: (context, event, heroChild) {
        final heroAnimation = scope.widget;

        return Transform.translate(
          offset: event.layoutRect.topLeft,
          child: SizedBox(
            width: event.layoutRect.size.width,
            height: event.layoutRect.size.height,
            child: VisibilityController(
              controller: scope.controller,
              child: heroAnimation.heroBuilder != null
                  ? heroAnimation.heroBuilder!(
                      context,
                      event.flightState,
                      heroChild,
                    )
                  : heroChild,
            ),
          ),
        );
      },
      child: scope.widget.child,
    );
  }
}

class VisibilityController extends SingleChildRenderObjectWidget {
  final HeroAnimationController controller;

  const VisibilityController({
    required this.controller,
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  HeroFlyingRenderObject createRenderObject(BuildContext context) {
    return HeroFlyingRenderObject(
      controller: controller,
    );
  }
}

class HeroFlyingRenderObject extends RenderProxyBox {
  late HeroAnimationController _controller;

  HeroFlyingRenderObject({
    required HeroAnimationController controller,
    RenderBox? child,
  }) : super(child) {
    _controller = controller;
  }

  void setController(HeroAnimationController value) {
    if (_controller != value) {
      _controller = value;
      markNeedsPaint();
    }
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_controller.isFlyVisible) {
      super.paint(context, offset);
    } else {
      context.pushOpacity(offset, 0, super.paint);
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (_controller.isFlyVisible) {
      super.visitChildrenForSemantics(visitor);
    }
  }
}
