
# HeroAnimation

Hero-animates it's child from one layout position to another within the same Route.
Works in Scrollable.

<p align="center">
	<img src="https://user-images.githubusercontent.com/88337052/219969853-3d7fe470-8f27-4a9c-b2b8-ad134b5cdcee.gif" />
</p>

# How it works?

Watch [on Youtube](https://www.youtube.com/watch?v=rut_h17D_kE&t=54s)

Read [the article](https://kirn.tech/hero-animation-within-the-same-route-in-flutter)

## Usage

Hero animation is triggered when between two frames, the position of a `HeroAnimation` with the same tag changes.

Use `key` to allow the Flutter framework to detect HeroAnimation repositioning under the same tree node.

`HeroAnimationScene` provides flight configuration to underlying heroes, which must be `HeroAnimation` widgets ancestor.

```dart
  Alignment alignment = Alignment.centerLeft;
  
  @override
  Widget build(BuildContext context) {
    
    return HeroAnimationScene(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        child: GestureDetector(
          onTap: () {
            setState(() {
              alignment = Alignment.centerRight;
            });
          },
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
```


## Repositioning within the same tree node.

<p align="center">
	<img src="https://user-images.githubusercontent.com/88337052/215544824-00f09d2b-0eff-47cf-b531-619709ca37ba.gif" />
</p>

#### Flight trigger:

```dart
     final _cups = ['0', '1', '2'];

     onPressed: () {
       setState(() {
         _cups.shuffle()
       });
       },
```

#### Here
`_cups` are mapped to ValueKey and a tag;

```dart
  @override
  Widget build(BuildContext context) {
    return Row(
          children: _cups
              .map(
                (e) => Expanded(
                  child: HeroAnimation.child(
                    key: ValueKey(e),
                    tag: e,
                    child: Image.asset(
                      'assets/im_cup.png',
                    ),
                  ),
                ),
         ).toList(),
    );
  }
```


## Repositioning between different tree nodes.

`HeroAnimation` allows to rebuild it's child according to `FlightState`

<p align="center">
	<img src="https://user-images.githubusercontent.com/88337052/215546276-6d858af3-8801-4dba-8b71-d8240877502e.gif" />
</p>

#### Flight trigger:

`_currentItem` is shown on the left, `_landedItems` are shown in column on the right.

```dart
       onPressed: () {
          setState(() {
          _landedItems.add(_currentItem);
          _itemPointer++;
          _currentItem = Item.values[_itemPointer];
          });
        }),
```

#### Here
Text change by `landedItem` hero is done by receiving `flightEnded` state for the first time.
Next hero animations within a column caused by adding new items are ignored by checking  `flightState.flightCount` > 1.

```dart
  @override
Widget build(BuildContext context) {
  return Column(
      children: <Widget>[
        ..._landedItems.map(
                (item)
            =>
                HeroAnimation.builder(
                  tag: item.name,
                  builder: (context, flightState, child) {
                    final firstFlightEnded = flightState.firstFlightEnded();

                    return AnimatedSwitcher(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        key: ValueKey(firstFlightEnded),
                        child: Text(
                          item.getTitle(firstFlightEnded),
                        ),
                      ),
                    );
                  },
                ))
      ]);
}
```