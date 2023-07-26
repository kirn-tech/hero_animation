import 'package:example/cup_game/cup_game_page.dart';
import 'package:example/flight_state_demo/flight_state_demo_page.dart';
import 'package:example/core/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const heroAnimationDuration = 1000;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppThemeProvider(
        theme: AppTheme.mobile(),
        child: DefaultTabController(
          length: 2,
          child: Builder(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: TabBar(
                  tabs: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        height: 55,
                        child: const Text('Flight state usage')),
                    Container(
                        alignment: Alignment.center,
                        height: 55,
                        child: const Text('Cup Game')),
                  ],
                ),
              ),
              body: const TabBarView(
                children: <Widget>[
                  FlightStateDemoPage(),
                  CupGamePage(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
