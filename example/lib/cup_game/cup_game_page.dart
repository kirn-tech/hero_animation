import 'package:example/cup_game/widgets.dart';
import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:hero_animation/hero_animation.dart';

class CupGamePage extends StatefulWidget {
  const CupGamePage({Key? key}) : super(key: key);

  @override
  State<CupGamePage> createState() => _CupGamePageState();
}

class _CupGamePageState extends State<CupGamePage> {
  final _cups = ['0', '1', '2'];
  late String _covered;

  @override
  void initState() {
    _covered = _cups[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeroAnimationScene(
      duration: const Duration(milliseconds: heroAnimationDuration),
      curve: Curves.easeOutCubic,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ..._cups.map(
                  (e) => Expanded(
                    key: ValueKey(e),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.8,
                      child: HeroAnimation.child(
                        tag: e,
                        key: ValueKey(e),
                        child: CupHero(
                          hasBall: e == _covered,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.only(bottom: 64),
            child: const Text('SHUFFLE'),
            onPressed: () {
              setState(() {
                _shuffle();
              });
            },
          ),
          CupertinoButton(
            padding: const EdgeInsets.only(bottom: 64),
            child: const Text('REMOVE'),
            onPressed: () {
              setState(() {
                if (_cups.isNotEmpty) {
                  _cups.removeAt(0);
                }
              });
            },
          )
        ],
      ),
    );
  }

  void _shuffle() {
    final unShuffled = List.of(_cups);
    _cups.shuffle();
    final shuffled = _cups;
    for (int i = 0; i < unShuffled.length; i++) {
      if (unShuffled[i] != shuffled[i]) {
        return;
      }
    }
    _shuffle();
  }
}
