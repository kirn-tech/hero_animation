import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero_animation/hero_animation.dart';
import 'package:hero_animation/src/hero/hero_animation.dart';
import 'package:hero_animation/src/hero/hero_fly.dart';
import 'package:hero_animation/src/hero/hero_still.dart';

void main() {
  testWidgets(
      'hero animation starts after position is changed, flight count is incremented',
      (tester) async {
    //initial position

    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.topCenter,
      ),
    );

    final HeroAnimationState superHeroState =
        tester.state(find.byType(HeroAnimation));
    final controller = superHeroState.scope.controller;

    expect(controller.flightState.value.isAppeared(), isTrue);

    expect(find.byType(HeroFly), findsNothing);
    expect(find.byType(HeroStill), findsOneWidget);

    //changed position for the first time

    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.bottomCenter,
      ),
    );

    expect(find.byType(HeroFly), findsOneWidget);
    expect(find.byType(HeroStill), findsOneWidget);

    expect(controller.flightState.value.isAppeared(), isTrue);

    await tester.pump();

    expect(controller.flightState.value.isFlightStarted(), isTrue);
    expect(controller.flightState.value.flightCount, 0);

    expect(controller.isFlyVisible, isTrue);

    await tester.pumpAndSettle();

    expect(controller.flightState.value.isFlightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 1);
    expect(controller.isFlyVisible, isFalse);

    //changed position for the second time

    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.centerLeft,
      ),
    );
    await tester.pump();

    expect(controller.flightState.value.isFlightStarted(), isTrue);
    expect(controller.isFlyVisible, isTrue);

    await tester.pumpAndSettle();

    expect(controller.flightState.value.isFlightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 2);
    expect(controller.isFlyVisible, isFalse);

    //position is not changed, hero animation is not started
    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.centerLeft,
      ),
    );
    await tester.pump();

    expect(controller.flightState.value.isFlightStarted(), isFalse);
    expect(controller.flightState.value.isFlightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 2);
    expect(controller.isFlyVisible, isFalse);

    expect(find.byType(HeroFly), findsOneWidget);
    expect(find.byType(HeroStill), findsOneWidget);
    expect(find.byType(HeroAnimation), findsOneWidget);
  });
}

class TestWidget extends StatelessWidget {
  final Alignment alignment;

  const TestWidget({
    Key? key,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeroAnimationScene(
        duration: const Duration(milliseconds: 500),
        child: Align(
          alignment: alignment,
          child: HeroAnimation.child(
            tag: 'tag_0',
            key: const ValueKey('tag_0'),
            child: const Text('SOME TEXT'),
          ),
        ),
      ),
    );
  }
}
