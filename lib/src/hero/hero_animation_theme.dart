import 'package:flutter/material.dart';

/// Provides flight configuration to underlying heroes.
/// Must be above [HeroAnimation] widgets.
class HeroAnimationTheme extends StatefulWidget {
  /// All hero animations under this widget will have the specified
  /// [duration], [curve], and [createRectTween] - interpolation between the start
  /// and end hero positions.
  const HeroAnimationTheme({
    Key? key,
    required this.duration,
    this.curve = Curves.linear,
    this.createRectTween = _defaultCreateTweenRect,
    required this.child,
  }) : super(key: key);

  /// Duration of hero flight animation.
  final Duration duration;

  /// Curve of hero animation.
  final Curve curve;

  /// Signature for a function that takes two [Rect] instances and returns a
  /// [RectTween] that transitions between them.
  /// This is used with a [HeroAnimationController] to provide an animation for
  /// [HeroAnimation] positions that look nicer than a linear movement.
  ///
  /// Default: [MaterialRectArcTween].
  final CreateRectTween createRectTween;

  final Widget child;

  @override
  HeroAnimationThemeState createState() => HeroAnimationThemeState();
}

class HeroAnimationThemeState extends State<HeroAnimationTheme>
    with TickerProviderStateMixin<HeroAnimationTheme> {
  @override
  Widget build(BuildContext context) {
    return _InheritedHeroAnimationThemeState(
      theme: widget,
      vsync: this,
      child: widget.child,
    );
  }
}

class _InheritedHeroAnimationThemeState extends InheritedWidget {
  const _InheritedHeroAnimationThemeState({
    Key? key,
    required this.theme,
    required this.vsync,
    required Widget child,
  }) : super(key: key, child: child);

  final HeroAnimationTheme theme;
  final TickerProvider vsync;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension BuildContextX on BuildContext {
  T? getInheritedWidget<T extends InheritedWidget>() {
    final InheritedElement? elem = getElementForInheritedWidgetOfExactType<T>();
    return elem?.widget as T?;
  }

  HeroAnimationTheme getHeroAnimationTheme() {
    final inheritedState =
        getInheritedWidget<_InheritedHeroAnimationThemeState>();
    assert(() {
      if (inheritedState == null) {
        throw FlutterError('No HeroAnimationTheme in tree above HeroAnimation');
      }
      return true;
    }());

    return inheritedState!.theme;
  }

  TickerProvider getHeroAnimationTickerProvider() {
    final inheritedState =
        getInheritedWidget<_InheritedHeroAnimationThemeState>();
    assert(() {
      if (inheritedState == null) {
        throw FlutterError('No HeroAnimationTheme in tree above HeroAnimation');
      }
      return true;
    }());

    return inheritedState!.vsync;
  }
}

RectTween _defaultCreateTweenRect(Rect? begin, Rect? end) {
  return MaterialRectArcTween(begin: begin, end: end);
}
