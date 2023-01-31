import 'package:flutter/widgets.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';
import 'package:hero_animation/src/hero/hero_animation_theme.dart';
import 'package:hero_animation/src/hero/widgets.dart';

/// Builds a [Widget] when given a concrete value of a [FlightState].
///
/// [HeroAnimationBuilder] is triggered via [ValueListenableBuilder] and it's
/// `child` parameter behaves similarly - If the `child` parameter provided to
/// the [HeroAnimationBuilder] is not null, the same `child` widget is passed back
/// to this [HeroAnimationBuilder] and should typically be incorporated in the
/// returned widget tree.
///
typedef HeroAnimationBuilder = Widget Function(
    BuildContext context, FlightState state, Widget? child);

/// Hero-animates it's child from one layout position to another within
/// the same Route.
///
/// If between two frames, the position of a `HeroAnimation` with the same [tag]
/// changes, a hero animation will be triggered.
///
/// Use `key` to allow Flutter framework to detect HeroAnimation repositioning
/// under the same tree node.
///
/// HeroAnimation can be created by two factories:
///
/// 1. [HeroAnimation.builder]
///
/// Provides [FlightState], so a child widget can rebuild it's subtree according
/// to it, e.g change opacity when a hero
/// flight started == [FlightState.flightStarted].
///
/// ``` dart
/// HeroAnimation.builder(
///       builder: (context, flightState, child) {
///         return AnimatedOpacity(
///           opacity: flightState.flightStartedMode() ? 0.5 : 1.0,
///           child: child,
///           ),
///         })
/// ```
///
/// 2. [HeroAnimation.child]
///
/// Creates HeroAnimation without [FlightState] rebuilds
///
///
///  ========================HOW IT FLIES?=====================================
///
///  Then same HeroAnimation [child] is inflated to
///  [HeroStill] and [HeroFly] widgets.
///
///  When HeroAnimation is still [HeroStill] is visible, [HeroFly]
///  is hidden on the same position.
///
///  When HeroAnimation is flying, than it's vise versa - [HeroFly] is visible,
///  [HeroStill] is hidden.
///
///  To get fly destination position HeroAnimation checks appearance in a tree of
///  other HeroAnimation widget with the same [tag],
///  than [HeroAnimationController] animates change of layout position
///  from one to another HeroAnimation.
///
/// ===========================================================================
///
/// [HeroFly] uses an [Overlay] usually created by [WidgetsApp] or
/// [MaterialApp], if this 'default' [Overlay] doesn't suit you, consider usage
/// of [HeroAnimationOverlay].
///

class HeroAnimation extends StatefulWidget {
  /// A [HeroAnimationBuilder] which builds a widget depending on the
  /// [FlightState]'s value.
  ///
  /// Can incorporate a [heroBuilder] value-independent widget subtree
  /// from the [child] parameter into the returned widget tree.
  ///
  /// is not null if created via factory [HeroAnimation.builder].
  final HeroAnimationBuilder? heroBuilder;

  /// The identifier for this particular hero.
  ///
  /// tag is used to trigger [child] flight, when within the same frame
  /// HeroAnimation with the same tag is removed from one place in a tree and
  /// is inserted into another.
  final String tag;

  /// The widget subtree that will "fly" from one hero position to another once
  /// hero with the same [tag] changes it's layout position.
  ///
  /// Changes in scale and aspect ratio work well in hero animations, as well as
  /// changes in layout or composition, which are made according to [FlightState]
  /// provided by [HeroAnimation.builder].
  final Widget? child;

  /// Build [FlightState] aware child subtree. `builder` is called each time
  /// FlightState changes. eg text is changed on `flightEndedMode()`
  /// ```dart
  /// HeroAnimation.builder(
  ///       tag: tag,
  ///       builder: (context, flightState, child) {
  ///         return AnimatedSwitcher(
  ///                 child: Text(flightState.flightEndedMode()
  ///                   ? 'flight ended text' : 'initial text' ));
  ///       },);
  /// ```
  factory HeroAnimation.builder({
    Key? key,
    required HeroAnimationBuilder builder,
    required String tag,
    Widget? child,
  }) {
    return HeroAnimation._(
        tag: tag, key: key, heroBuilder: builder, child: child);
  }

  factory HeroAnimation.child({
    Key? key,
    required String tag,
    required Widget child,
  }) {
    return HeroAnimation._(tag: tag, key: key, child: child);
  }

  /// Creates a [HeroAnimation].
  ///
  /// If between two frames, the position of a [HeroAnimation] with the same tag
  /// changes, a local hero animation will be triggered.
  const HeroAnimation._({
    Key? key,
    this.child,
    this.heroBuilder,
    required this.tag,
  }) : super(key: key);

  @override
  HeroAnimationState createState() => HeroAnimationState();
}

class HeroAnimationState extends State<HeroAnimation> {
  static final Map<String, HeroEntry> _map = <String, HeroEntry>{};
  late HeroAnimationController controller;

  @override
  void initState() {
    super.initState();
    if (!_map.containsKey(widget.tag)) {
      final scope = context.getHeroAnimationTheme();
      final vsync = context.getHeroAnimationTickerProvider();
      final controller = HeroAnimationController(
        duration: scope.duration,
        provideRectTween: scope.createRectTween,
        curve: scope.curve,
        vsync: vsync,
      );
      final flyOverlay = HeroFly.insertOverlay(context, controller, widget);
      _map.putIfAbsent(widget.tag, () => HeroEntry(controller, flyOverlay, 1));
    } else {
      _map[widget.tag]?.count++;
    }
    controller = _map[widget.tag]!.controller;
  }

  @override
  void dispose() {
    final controllerEntry = _map[widget.tag];
    if (controllerEntry != null) {
      controllerEntry.count--;
      if (controllerEntry.count == 0) {
        _map.remove(widget.tag);
        controllerEntry.flyOverlay.remove();
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeroStill(
      controller: controller,
      child: widget.heroBuilder != null
          ? ValueListenableBuilder<FlightState>(
              valueListenable: controller.flightState,
              builder: (context, value, child) =>
                  widget.heroBuilder!.call(context, value, child),
              child: widget.child,
            )
          : widget.child,
    );
  }
}

/// HeroAnimation FlightState, allows hero child subtree to change its
/// properties accordingly.
///
/// FlightState:
///
/// [appeared] - [HeroStill] is rendered for the first time,
/// [HeroFly] is invisible
///
/// [flightStarted] - [HeroFly] becomes visible and starts to 'fly',
/// [HeroStill] is invisible.
/// Might be called multiple time for the same hero,
/// on each call [flightCount] is incremented.
///
/// [flightEnded] -  [HeroStill] becomes visible at new position,
/// [HeroFly] is invisible
///
///
/// [flightCount] could be used by hero child subtree to distinguish between,
/// 'intentional' flight and some adjustment flights that could happen when
/// adjacent widget layout is changed, e.g. new child is added to a parent Row or Column.
///
class FlightState {
  final Mode _mode;
  final int flightCount;

  FlightState._(this._mode, {required this.flightCount});

  bool initial() => _mode == Mode.initial;

  bool appeared() => _mode == Mode.appeared;

  bool flightStarted() => _mode == Mode.flightStarted;

  bool flightEnded() => _mode == Mode.flightEnded;

  @override
  String toString() {
    return 'FlightState: $_mode, flightCount: $flightCount';
  }
}

///Incapsulates [FlightState] instance creation.
extension FlightStateFactory on FlightState {
  static FlightState onInit() {
    return FlightState._(Mode.initial, flightCount: 0);
  }

  FlightState onFlightStarted() {
    return FlightState._(Mode.flightStarted, flightCount: flightCount + 1);
  }

  FlightState onAppeared() {
    return FlightState._(Mode.appeared, flightCount: flightCount);
  }

  FlightState onFlightEnded() {
    return FlightState._(Mode.flightEnded, flightCount: flightCount);
  }
}

enum Mode {
  initial,
  appeared,
  flightStarted,
  flightEnded,
}

class HeroEntry {
  final HeroAnimationController controller;
  final OverlayEntry flyOverlay;
  int count;

  HeroEntry(
    this.controller,
    this.flyOverlay,
    this.count,
  );
}
