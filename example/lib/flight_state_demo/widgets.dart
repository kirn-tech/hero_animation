part of 'flight_state_demo_page.dart';

class _ItemHero extends StatelessWidget {
  final Item item;

  const _ItemHero({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeroAnimation.builder(
      tag: item.name,
      key: ValueKey(item.name),
      builder: (c, flightState, _) => AnimatedOpacity(
        duration: const Duration(milliseconds: heroAnimationDuration ~/ 2),
        opacity: flightState.initial() ? 0.0 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: heroAnimationDuration),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: item.color(),
            borderRadius:
                BorderRadius.circular(flightState.flightCount < 1 ? 4 : 100),
          ),
        ),
      ),
    );
  }
}

class StepCompleter extends StatefulWidget {
  const StepCompleter({Key? key}) : super(key: key);

  @override
  State<StepCompleter> createState() => _StepCompleterState();
}

class _StepCompleterState extends State<StepCompleter> {
  static final _steps = [
    '1. How to apply HeroAnimation to YourWidget?',
    '2. How to animate YourWidget itself during the flight?',
    '3. How to animate YourWidget\'s size change?',
    '4. How to animate YourWidget appearance?',
  ];
  static final ColorTween _itemTextColorTween =
      ColorTween(begin: Colors.black87, end: Colors.black54);

  @override
  Widget build(BuildContext context) {
    final textStyling = context.textStyling;
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'How to use HeroAnimation?',
              style: textStyling.h2.copyWith(color: Colors.green),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AnimatedItemPicker(
            axis: Axis.vertical,
            multipleSelection: true,
            itemCount: _steps.length,
            duration: const Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
            pressedOpacity: 0.75,
            itemBuilder: (i, animValue) => Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Stack(children: [
                Text(
                  _steps[i],
                  style: textStyling.h3.copyWith(
                    color: _itemTextColorTween.transform(animValue),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: LinePainter(animValue),
                  ),
                ),
              ]),
            ),
            onItemPicked: (_, __) {},
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  late Paint _paint;
  final double _progress;
  static const _strokeWidth = 2.0;

  LinePainter(this._progress) {
    _paint = Paint()
      ..color = Colors.green[600] ?? Colors.green
      ..strokeWidth = _strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height / 2 + _strokeWidth;
    canvas.drawLine(
        Offset(0.0, height), Offset(size.width * _progress, height), _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}
