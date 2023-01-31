import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';

class HeroFlyingRenderObject extends RenderProxyBox {
  late HeroAnimationController _controller;

  HeroFlyingRenderObject({
    required HeroAnimationController controller,
    RenderBox? child,
  }) : super(child) {
    _controller = controller..addListener(markNeedsLayout);
  }

  set controller(HeroAnimationController value) {
    if (_controller != value) {
      _controller.removeListener(markNeedsLayout);
      _controller = value;
      _controller.addListener(markNeedsLayout);
      markNeedsPaint();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(markNeedsLayout);
    super.dispose();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    return false;
  }

  @override
  void performLayout() {
    final Size? requestedSize = _controller.requestedSize;
    final BoxConstraints childConstraints = requestedSize == null
        ? constraints
        : constraints.enforce(BoxConstraints.tight(requestedSize));
    if (child != null) {
      child!.layout(childConstraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect? animR = _controller.animation?.value;
    if (animR != null) {
      super.paint(context, Offset(animR.left, animR.top));
    } else {
      context.pushOpacity(offset, 0, super.paint);
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (_controller.isAnimating) {
      super.visitChildrenForSemantics(visitor);
    }
  }
}

class HeroStillRenderObject extends RenderProxyBox {
  late HeroAnimationController _controller;

  HeroStillRenderObject({
    required HeroAnimationController controller,
    RenderBox? child,
  }) : super(child) {
    _controller = controller..addStatusListener(_onAnimationStatusChanged);
  }

  set controller(HeroAnimationController controller) {
    if (_controller != controller) {
      _controller.removeStatusListener(_onAnimationStatusChanged);
      _controller = controller;
      _controller.addStatusListener(_onAnimationStatusChanged);
      markNeedsPaint();
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      _controller.flightStarted();
    }

    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _controller.flightEnded();
      markNeedsPaint();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    return !_controller.isAnimating &&
        super.hitTest(result, position: position!);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = Rect.fromPoints(offset, size.bottomRight(offset));

    _controller.animateIfNeeded(rect);

    final painter = _controller.isAnimating
        ? (PaintingContext context, Offset offset) =>
            context.pushOpacity(offset, 0, super.paint)
        : super.paint;

    context.pushTransform(
        needsCompositing, offset, Matrix4.identity(), painter);

    if (_controller.isIdle() && rect.hasSize()) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _controller.appeared());
    }
  }
}

extension RectX on Rect {
  bool hasSize() {
    return top != bottom && left != right;
  }
}
