import 'package:collection/collection.dart';
import 'package:example/cup_game/widgets.dart';
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
    return HeroAnimationOverlay(
      child: Column(
        children: [
          Expanded(
            child: Row(
                children: _cups
                    .map(
                      (e) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: CupHero(
                            key: ValueKey(e),
                            tag: e,
                            hasBall: _covered == e,
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
          CupertinoButton(
            padding: const EdgeInsets.only(bottom: 64),
            child: const Text('SHUFFLE'),
            onPressed: () {
              //should be disabled when hero animation runs
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
    if (const ListEquality().equals(unShuffled, shuffled)) {
      _shuffle();
    }
  }
}
