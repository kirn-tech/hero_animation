import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hero_animation/src/hero/hero_animation.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';
import 'package:hero_animation/src/hero/render_objects.dart';

/// Flying part of [HeroAnimation]. Flies between [HeroStill] previous and
/// new positions.

class HeroFly extends SingleChildRenderObjectWidget {
  final HeroAnimationController controller;

  const HeroFly._({
    Key? key,
    required this.controller,
    Widget? child,
  }) : super(key: key, child: child);

  const HeroFly({
    Key? key,
    required this.controller,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  HeroFlyingRenderObject createRenderObject(BuildContext context) {
    return HeroFlyingRenderObject(
      controller: controller,
    );
  }

  static OverlayEntry insertOverlay(BuildContext context,
      HeroAnimationController controller, HeroAnimation hero) {
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return HeroFly._(
          controller: controller,
          child: hero.heroBuilder != null
              ? ValueListenableBuilder<FlightState>(
                  valueListenable: controller.flightState,
                  builder: (context, value, child) =>
                      hero.heroBuilder!.call(context, value, child),
                  child: hero.child,
                )
              : hero.child,
        );
      },
    );

    final overlayState = Overlay.of(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      overlayState.insert(overlayEntry);
    });
    return overlayEntry;
  }
}

/// Still part of [HeroAnimation]. It's position change triggers [HeroFly] animation.

class HeroStill extends SingleChildRenderObjectWidget {
  final HeroAnimationController controller;

  const HeroStill({
    Key? key,
    required this.controller,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  HeroStillElement createElement() {
    return HeroStillElement(this);
  }

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
  }
}

class HeroStillElement extends SingleChildRenderObjectElement {
  HeroStillElement(HeroStill widget) : super(widget);

  @override
  HeroStill get widget => super.widget as HeroStill;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (!widget.controller.isAnimating) {
      super.debugVisitOnstageChildren(visitor);
    }
  }
}
