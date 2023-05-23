import 'dart:ui';

/// HeroAnimation FlightState, allows the hero child subtree to change its
/// properties accordingly.
///
/// FlightState:
///
/// [isAppeared] - [HeroStill] is rendered for the first time,
/// [HeroFly] is invisible
///
/// [isFlightStarted] - [HeroFly] becomes visible and starts to 'fly',
/// [HeroStill] is invisible.
/// Might be called multiple times for the same hero,
/// on each call [flightCount] is incremented.
///
/// [isFlightEnded] -  [HeroStill] becomes visible at a new position,
/// [HeroFly] is invisible
///
///
/// [flightCount] could be used by the hero child subtree to distinguish between,
/// 'intentional' flight and some adjustment flights that could happen when
/// adjacent widget layout is changed, e.g. new child is added to a parent Row or Column.
///
class FlightState {
  final FlightMode _mode;
  final int flightCount;

  FlightState._(this._mode, {required this.flightCount});

  bool isInitial() => _mode == FlightMode.initial;

  bool isAppeared() => _mode == FlightMode.appeared;

  bool isFlightStarted() => _mode == FlightMode.flightStarted;

  bool isFlightEnded() => _mode == FlightMode.flightEnded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightState &&
          runtimeType == other.runtimeType &&
          _mode == other._mode &&
          flightCount == other.flightCount;

  @override
  int get hashCode => _mode.hashCode ^ flightCount.hashCode;

  @override
  String toString() {
    return 'FlightState: $_mode, flightCount: $flightCount';
  }
}

///Encapsulates [FlightState] instance creation.
extension FlightStateFactory on FlightState {
  static FlightState initial() {
    return FlightState._(FlightMode.initial, flightCount: 0);
  }

  FlightState onFlightStarted() {
    return FlightState._(FlightMode.flightStarted, flightCount: flightCount);
  }

  FlightState onAppeared() {
    return FlightState._(FlightMode.appeared, flightCount: flightCount);
  }

  FlightState onFlightEnded() {
    return FlightState._(FlightMode.flightEnded, flightCount: flightCount + 1);
  }
}

extension FlightStateProperties on FlightState {
  bool firstFlightStarted() => isFlightStarted() || flightCount > 0;

  bool firstFlightEnded() => isFlightEnded() || flightCount > 0;
}

enum FlightMode {
  initial,
  appeared,
  flightStarted,
  flightEnded,
}

class Event {
  ///Current FlightState
  final FlightState flightState;
  ///Current HeroAnimation position.
  ///Used by HeroFly only.
  final Rect layoutRect;

  Event({
    required this.flightState,
    required this.layoutRect,
  });

  @override
  String toString() {
    return 'Event{flightState: $flightState, layoutRect: $layoutRect}';
  }

  Event copyWith({FlightState? flightState, Rect? layoutRect}) {
    return Event(
        flightState: flightState ?? this.flightState,
        layoutRect: layoutRect ?? this.layoutRect);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          flightState == other.flightState &&
          layoutRect == other.layoutRect;

  @override
  int get hashCode => flightState.hashCode ^ layoutRect.hashCode;
}
