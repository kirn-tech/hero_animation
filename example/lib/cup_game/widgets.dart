import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CupHero extends StatefulWidget {
  final bool hasBall;

  const CupHero({required this.hasBall, Key? key}) : super(key: key);

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () {
              if (_controller.value > 0.0) {
                _controller.reverse();
              } else {
                _controller.forward(from: 0.0);
              }
            },
            child: Stack(
              children: [
                widget.hasBall
                    ? Positioned.fill(
                        top: constraints.maxHeight / 7,
                        child: FractionallySizedBox(
                          widthFactor: 0.3,
                          heightFactor: 0.3,
                          child: Image.asset(
                            'assets/im_ball.png',
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: (constraints.maxHeight / 2) * _animation.value,
                  child: Image.asset(
                    'assets/im_cup.png',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
