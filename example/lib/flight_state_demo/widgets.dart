part of 'flight_state_demo_page.dart';

class _TitleHero extends StatelessWidget {
  final String text;

  const _TitleHero({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyling = context.textStyling;
    return HeroAnimation.child(
      tag: text,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: textStyling.h1,
        ),
      ),
    );
  }
}

class _ItemHero extends StatefulWidget {
  final Item item;

  const _ItemHero({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<_ItemHero> createState() => _ItemHeroState();
}

class _ItemHeroState extends State<_ItemHero> {
  @override
  Widget build(BuildContext context) {
    final textStyling = context.textStyling;
    return HeroAnimation.builder(
      tag: widget.item.name,
      builder: (context, flightState, child) {
        final firstFlightEnded =
            flightState.flightEnded() || flightState.flightCount > 1;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeIn,
          opacity: flightState.initial() ? 0.0 : 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: Container(
                alignment: Alignment.centerLeft,
                key: ValueKey(firstFlightEnded),
                child: Text(
                  widget.item.getTitle(firstFlightEnded),
                  textAlign: TextAlign.start,
                  style: textStyling.h2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
