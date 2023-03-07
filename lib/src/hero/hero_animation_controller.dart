import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:hero_animation/src/hero/hero_animation.dart';

/// Signature for a function that takes two [Rect] instances and returns a
/// [RectTween] that transitions between them.
typedef RectTweenProvider = Tween<Rect?> Function(Rect begin, Rect end);

class HeroAnimationController {
  final _flightState = ValueNotifier(FlightStateFactory.onInit());

  ValueListenable<FlightState> get flightState => _flightState;

  late final AnimationController _controller =
      AnimationController(vsync: _vsync, duration: _initialDuration)
        ..addStatusListener(_onAnimationStatusChanged);

  final TickerProvider _vsync;
  final Duration _initialDuration;

  Animation<Rect?>? _animation;

  Animation<Rect?>? get animation => _animation;
  Rect? _lastRect;

  final Curve _curve;
  final RectTweenProvider _provideRectTween;

  bool _isAnimating = false;

  HeroAnimationController({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required RectTweenProvider provideRectTween,
  })  : _vsync = vsync,
        _curve = curve,
        _provideRectTween = provideRectTween,
        _initialDuration = duration;

  bool get isAnimating => _isAnimating;

  Size? get requestedSize => _animation?.value?.size ?? _lastRect?.size;

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animation = AlwaysStoppedAnimation(_animation?.value);
      _controller.reset();
      _isAnimating = false;
    }
  }

  void animateIfNeeded(Rect rect) {
    if (_lastRect != null && _lastRect != rect) {
      _isAnimating = true;

      _animation = _controller
          .drive(CurveTween(curve: _curve))
          .drive(_provideRectTween(_lastRect!, rect));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!isAnimating) {
          _controller.forward();
        } else {
          _controller.animateTo(1,
              duration: _controller.duration! * (1 - _controller.value));
        }
      });
    }
    _lastRect = rect;
  }

  bool isIdle() {
    return _flightState.value.initial();
  }

  void appeared() {
    _flightState.value = _flightState.value.onAppeared();
  }

  void flightEnded() {
    _flightState.value = _flightState.value.onFlightEnded();
  }

  void flightStarted() {
    _flightState.value = _flightState.value.onFlightStarted();
  }

  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  void addStatusListener(AnimationStatusListener listener) {
    _controller.addStatusListener(listener);
  }

  void removeStatusListener(AnimationStatusListener listener) {
    _controller.removeStatusListener(listener);
  }

  void dispose() {
    _controller.dispose();
  }
}
