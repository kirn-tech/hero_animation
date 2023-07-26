import 'dart:math';

import 'package:example/flight_state_demo/model.dart';
import 'package:example/core/app_theme.dart';
import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hero_animation/hero_animation.dart';

part 'widgets.dart';

class FlightStateDemoPage extends StatefulWidget {
  const FlightStateDemoPage({Key? key}) : super(key: key);

  @override
  State<FlightStateDemoPage> createState() => _FlightStateDemoPageState();
}

class _FlightStateDemoPageState extends State<FlightStateDemoPage> {
  final List<Item> _landedItems = <Item>[];
  Item? _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = Item.values[0];
  }

  @override
  Widget build(BuildContext context) {
    final textStyling = context.textStyling;

    return HeroAnimationScene(
      duration: const Duration(milliseconds: heroAnimationDuration),
      curve: Curves.easeOutCubic,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ..._landedItems.map(
                    (item) => SizedBox(
                      height: 110,
                      width: 110,
                      child: _ItemHero(
                        item: item,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                  _currentItem != null
                      ? SizedBox(
                          width: 55,
                          height: 55,
                          child: _ItemHero(
                            item: _currentItem!,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    onPressed: _landedItems.length < Item.values.length - 1
                        ? () {
                            setState(() {
                              if (_landedItems.length <
                                  Item.values.length - 1) {
                                final index =
                                    Random().nextInt(_landedItems.length + 1);

                                _landedItems.insert(index, _currentItem!);

                                _currentItem = Item.values[_nextItemIndex()];
                              }
                            });
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        'MOVE',
                        style: textStyling.h2.copyWith(color: Colors.red),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _nextItemIndex() {
    if (_landedItems.length == Item.values.length - 1) {
      return Item.values.length - 1;
    }
    int next = Random().nextInt(Item.values.length - 1);

    final set = Set.of(_landedItems.map((e) => Item.values.indexOf(e)));
    if (set.contains(next)) {
      return _nextItemIndex();
    }
    return next;
  }
}
