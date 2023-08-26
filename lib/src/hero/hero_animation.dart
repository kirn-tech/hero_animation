import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hero_animation/src/hero/hero_animation_controller.dart';
import 'package:hero_animation/src/hero/hero_animation_scene.dart';
import 'package:hero_animation/src/hero/hero_fly.dart';
import 'package:hero_animation/src/hero/hero_still.dart';
import 'package:hero_animation/src/hero/models.dart';

/// Builds a [Widget] when given a concrete value of a [FlightState].
///
/// [HeroAnimationBuilder] is triggered via [ValueListenableBuilder] and it's
/// `child` parameter behaves similarly - If the `child` parameter provided to
/// the [HeroAnimationBuilder] is not null, the same `child` widget is
/// passed back to this [HeroAnimationBuilder] and should typically be
/// incorporated in the returned widget tree.
///
typedef HeroAnimationBuilder = Widget Function(
  BuildContext context,
  FlightState state,
  Widget? child,
);

/// Hero-animates its child from one layout position to another within
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
/// Provides [FlightState], so a child widget can rebuild its subtree according
/// to it, e.g change opacity when a hero
/// flight started == [FlightState.isFlightStarted].
///
/// ``` dart
/// HeroAnimation.builder(
///       builder: (context, flightState, child) {
///         return AnimatedOpacity(
///           opacity: flightState.isFlightStarted() ? 0.5 : 1.0,
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
///  HeroAnimation [child] is inflated to
///  [HeroStill] and [HeroFly] widgets.
///
///  When a hero is still - [HeroStill] is visible, [HeroFly]
///  is hidden in the same position.
///
///  When the hero flies, then it's vice versa - [HeroFly] is visible,
///  [HeroStill] is hidden.
///
///  To get the fly destination position HeroAnimation checks the
///  appearance in a tree of another HeroAnimation widget with the same [tag],
///  than [HeroAnimationController] animates change of layout position
///  from one to another HeroAnimation.
///
/// ===========================================================================
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
  /// `tag` is used to trigger [child] flight, when within the same frame
  /// HeroAnimation with the same tag is removed from one place in a tree and
  /// is inserted into another.
  final String tag;

  /// The widget subtree that will "fly" from one hero position to another once
  /// hero with the same [tag] changes its layout position.
  ///
  /// Changes in scale and aspect ratio work well in hero animations, as well as
  /// changes in layout or composition, which are made according
  /// to [FlightState] provided by [HeroAnimation.builder].
  final Widget? child;

  /// Build [FlightState] aware child subtree. `builder` is called each time
  /// FlightState changes. eg text is changed on `flightEndedMode()`
  /// ```dart
  /// HeroAnimation.builder(
  ///       tag: tag,
  ///       builder: (context, flightState, child) {
  ///         return AnimatedSwitcher(
  ///                 child: Text(flightState.isFlightEnded()
  ///                   ? 'flight ended text' : 'initial text' ));
  ///       },);
  /// ```
  factory HeroAnimation.builder({
    required HeroAnimationBuilder builder,
    required String tag,
    Key? key,
    Widget? child,
  }) {
    return HeroAnimation._(
      tag: tag,
      key: key,
      heroBuilder: builder,
      child: child,
    );
  }

  factory HeroAnimation.child({
    required String tag,
    required Widget child,
    Key? key,
  }) {
    return HeroAnimation._(tag: tag, key: key, child: child);
  }

  /// Creates a [HeroAnimation].
  ///
  /// If between two frames, the position of a [HeroAnimation] with the same tag
  /// changes, a local hero animation will be triggered.
  const HeroAnimation._({
    required this.tag,
    Key? key,
    this.child,
    this.heroBuilder,
  }) : super(key: key);

  @override
  HeroAnimationState createState() => HeroAnimationState();
}

class HeroAnimationState extends State<HeroAnimation> {
  late ScopeRegistrar scopeRegistrar;
  late Scope scope;

  @override
  void initState() {
    scopeRegistrar = context.findAncestorStateOfType<HeroAnimationSceneState>()
        as ScopeRegistrar;
    scope = scopeRegistrar.register(widget);

    ServicesBinding.instance.addPostFrameCallback((_) {
      if (scope.controller.flightState.value.isInitial()) {
        scope.controller.onAppeared();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scopeRegistrar.unregister(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeroStill(scope: scope);
  }
}
