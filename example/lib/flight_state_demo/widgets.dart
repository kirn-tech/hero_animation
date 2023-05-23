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
        opacity: flightState.isInitial() ? 0.0 : 1.0,
        duration: const Duration(milliseconds: heroAnimationDuration ~/ 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: heroAnimationDuration),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: item.color(),
            borderRadius: BorderRadius.circular(
                flightState.firstFlightStarted() ? 100 : 10),
          ),
        ),
      ),
    );
  }
}
