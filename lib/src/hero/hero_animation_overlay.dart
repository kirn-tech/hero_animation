import 'package:flutter/widgets.dart';

/// HeroAnimation appears as `OverlayEntry`, inserted in `Overlay` which is usually
/// created by `WidgetsApp` or a `MaterialApp`, but if rendering area of HeroAnimation
/// doesn't match rendering area of 'default' Overlay, eg. hero is added in `TabBarView`
/// than to adjust it's rendering area use `HeroAnimationFlyOverlay`.
///
class HeroAnimationOverlay extends StatefulWidget {
  const HeroAnimationOverlay({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  HeroAnimationOverlayState createState() => HeroAnimationOverlayState();
}

class HeroAnimationOverlayState extends State<HeroAnimationOverlay> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (context) => widget.child!),
        ],
      ),
    );
  }
}