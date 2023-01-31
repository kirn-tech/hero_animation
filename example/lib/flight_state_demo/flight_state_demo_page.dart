import 'package:example/flight_state_demo/model.dart';
import 'package:example/core/app_theme.dart';
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
  late Item? _currentItem;

  int _itemPointer = 0;

  @override
  void initState() {
    super.initState();
    _currentItem = Item.values[_itemPointer];
  }

  @override
  Widget build(BuildContext context) {
    final textStyling = context.textStyling;
    return HeroAnimationOverlay(
      child: Material(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: SizedBox.shrink(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Start',
                                style: textStyling.h1,
                              ),
                            ),
                            _currentItem != null
                                ? _ItemHero(
                                    key: ValueKey(_currentItem),
                                    item: _currentItem!,
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
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const _TitleHero(
                            text: 'Finish',
                            key: ValueKey('Finish'),
                          ),
                          ..._landedItems.map(
                            (item) => _ItemHero(
                              item: item,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: CupertinoButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        'FLY',
                        style: textStyling.h2.copyWith(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_itemPointer <= Item.values.length - 2) {
                          _landedItems.add(_currentItem!);
                          _itemPointer++;
                          _currentItem = Item.values[_itemPointer];
                        }
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
