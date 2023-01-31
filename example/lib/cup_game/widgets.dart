import 'package:flutter/widgets.dart';
import 'package:hero_animation/hero_animation.dart';

class CupHero extends StatefulWidget {
  final String tag;
  final bool hasBall;

  const CupHero({required this.tag, required this.hasBall, required Key key})
      : super(key: key);

  @override
  State<CupHero> createState() => _CupHeroState();
}

class _CupHeroState extends State<CupHero> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.value > 0.0) {
          _controller.reverse();
        } else {
          _controller.forward(from: 0.0);
        }
      },
      child: HeroAnimation.child(
        tag: widget.tag,
        child: Stack(
          children: [
            widget.hasBall
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/im_ball.png',
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Transform.translate(
              offset: Offset(0.0, -100.0 * _animation.value),
              child: Image.asset(
                'assets/im_cup.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
