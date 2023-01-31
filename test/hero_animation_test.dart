import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero_animation/src/hero/hero_animation.dart';
import 'package:hero_animation/src/hero/hero_animation_theme.dart';
import 'package:hero_animation/src/hero/widgets.dart';

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
    final controller = superHeroState.controller;
    expect(controller.flightState.value.appeared(), isTrue);
    expect(find.byType(HeroFly), findsNothing);
    expect(find.byType(HeroStill), findsOneWidget);
    await tester.pump();

    expect(find.byType(HeroFly), findsOneWidget);
    expect(find.byType(HeroStill), findsOneWidget);

    //changed position for the first time

    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.bottomCenter,
      ),
    );

    expect(controller.flightState.value.flightStarted(), isTrue);

    expect(controller.isAnimating, isTrue);

    await tester.pumpAndSettle();

    expect(controller.flightState.value.flightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 1);

    expect(controller.isAnimating, isFalse);

    //changed position for the second time

    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.centerLeft,
      ),
    );

    expect(controller.flightState.value.flightStarted(), isTrue);

    expect(controller.isAnimating, isTrue);
    await tester.pumpAndSettle();
    expect(controller.flightState.value.flightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 2);

    expect(controller.isAnimating, isFalse);

    //position is not changed, hero animation is not started
    await tester.pumpWidget(
      const TestWidget(
        alignment: Alignment.centerLeft,
      ),
    );
    expect(controller.isAnimating, isFalse);
    expect(controller.flightState.value.flightEnded(), isTrue);
    expect(controller.flightState.value.flightCount, 2);

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
      home: HeroAnimationTheme(
        duration: const Duration(milliseconds: 500),
        child: Align(
          alignment: alignment,
          child: HeroAnimation.child(
            tag: 'tag_0',
            child: const Text('SOME TEXT'),
          ),
        ),
      ),
    );
  }
}
