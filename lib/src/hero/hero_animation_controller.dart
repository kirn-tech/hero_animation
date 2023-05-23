import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'core.dart';
import 'models.dart';

/// Signature for a function that takes two [Rect] instances and returns a
/// [RectTween] that transitions between them.
typedef RectTweenProvider = Tween<Rect?> Function(Rect begin, Rect end);

class HeroAnimationController {
  ///Single source of events for layout position and visibility of HeroFly
  ///and HeroStill.
  ///Listened directly by HeroFly.
  late ValueNotifier<Event> _eventPipeline;

  /// Reduced [_eventPipeline] by [ValueNotifierMapper]
  /// Listened directly by HeroStill.
  late ValueNotifier<FlightState> _flightState;

  late AnimationController _controller;

  final TickerProvider _vsync;
  final Duration _initialDuration;
  final Curve _curve;
  final RectTweenProvider _provideRectTween;

  Animation<Rect?>? _animation;
  Rect? _lastRect;
  Size? _currentScreenSize;

  bool _heroRepositioned = false;

  ///Actual for Web
  bool _screenSizeChanged = false;

  String tag;

  HeroAnimationController({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required RectTweenProvider provideRectTween,
    required this.tag,
  })  : _vsync = vsync,
        _curve = curve,
        _provideRectTween = provideRectTween,
        _initialDuration = duration {
    final initialState = FlightStateFactory.initial();

    _eventPipeline = ValueNotifier<Event>(Event(
      flightState: initialState,
      layoutRect: Rect.zero,
    ));

    _flightState = ValueNotifierMapper<Event, FlightState>(
        source: _eventPipeline,
        map: (event) => event.flightState,
        initialValue: initialState);

    _controller =
        AnimationController(vsync: _vsync, duration: _initialDuration);
    _controller.addStatusListener(_resetAnimationListener);
    _controller.addListener(_emitAnimationState);
  }

  void dispose() {
    _flightState.dispose();
    _eventPipeline.dispose();
    _controller.removeListener(_emitAnimationState);
    _controller.removeStatusListener(_resetAnimationListener);
    _controller.dispose();
  }

  ValueListenable<Event> get layoutRectAndFlightState => _eventPipeline;

  ValueListenable<FlightState> get flightState => _flightState;

  bool get isFlyVisible =>
      ((_controller.isAnimating || _heroRepositioned) && !_screenSizeChanged);

  void animateIfNeeded(Rect rect, Size screenSize) async {
    _heroRepositioned = rect != _lastRect;
    _screenSizeChanged = screenSize != _currentScreenSize;
    if (_layoutRectHasChanged(rect) &&
        _checkIsScreenSizeIsTheSame(screenSize)) {
      _animation = _controller
          .drive(CurveTween(curve: _curve))
          .drive(_provideRectTween(_lastRect!, rect));

      if (!_controller.isAnimating) {
        _controller.forward();
      } else {
        _controller.animateTo(1,
            duration: _controller.duration! * (1 - _controller.value));
      }
    }

    _lastRect = rect;
    _currentScreenSize = screenSize;
    if (_screenSizeChanged) {
      _repositionFly();
    }
  }

  void onAppeared() {
    _setAnimationState(mode: FlightMode.appeared);
  }

  bool _checkIsScreenSizeIsTheSame(Size screenSize) =>
      _currentScreenSize != null && _currentScreenSize == screenSize;

  bool _layoutRectHasChanged(Rect rect) =>
      _lastRect != null && _lastRect != rect;

  void _repositionFly() {
    ServicesBinding.instance.addPostFrameCallback((_) {
      _setAnimationState(layoutRect: _lastRect);
    });
  }

  void _emitAnimationState() {
    final status = _controller.status;
    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      _setAnimationState(mode: FlightMode.flightStarted);
    } else if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _setAnimationState(mode: FlightMode.flightEnded);
    } else {
      _setAnimationState(layoutRect: _animation?.value);
    }
  }

  _setAnimationState({Rect? layoutRect, FlightMode? mode}) {
    FlightState? newFlightState;

    switch (mode) {
      case FlightMode.appeared:
        newFlightState = _eventPipeline.value.flightState.onAppeared();
        break;
      case FlightMode.flightStarted:
        if (!flightState.value.isFlightStarted()) {
          newFlightState = _eventPipeline.value.flightState.onFlightStarted();
        }
        break;
      case FlightMode.flightEnded:
        if (!flightState.value.isFlightEnded()) {
          newFlightState = _eventPipeline.value.flightState.onFlightEnded();
        }
        break;
      default:
    }

    _eventPipeline.value = _eventPipeline.value.copyWith(
        layoutRect: layoutRect ?? _animation?.value,
        flightState: newFlightState ?? _eventPipeline.value.flightState);
  }

  void _resetAnimationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animation = AlwaysStoppedAnimation(_animation?.value);
      _controller.reset();
    }
  }
}
