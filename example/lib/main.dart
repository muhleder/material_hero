// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_hero/material_hero.dart';

void main() async {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialHeroScope(
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Container(
              color: Colors.yellowAccent,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: ElevatedButton(
                      onPressed: () => setState(() => clicked = !clicked),
                      child: Text('Clicked is $clicked'),
                    ),
                  ),
                  if (!clicked)
                    Positioned(
                      top: 27,
                      left: 103,
                      child: MaterialHero(
                        tag: 'animals',
                        color: Colors.orangeAccent,
                        child: Container(
                          width: 100,
                          height: 50,
                          // color: Colors.black.withOpacity(0.2),
                          child: AardvarkBox(),
                        ),
                      ),
                    ),
                  // if (clicked)
                  //   Positioned(
                  //       top: 300,
                  //       left: 300,
                  //       child: MaterialHero(
                  //         tag: 'promo',
                  //         color: Colors.deepPurpleAccent,
                  //         child: const SizedBox(width: 100, height: 100, child: Text('Hello')),
                  //       )),
                  if (clicked)
                    Positioned(
                      top: 300,
                      left: 103,
                      width: 150,
                      height: 75,
                      child: MaterialHero(
                        tag: 'animals',
                        color: Colors.redAccent,
                        child: const BeaverBox(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MonthPromo extends StatelessWidget {
  const MonthPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.orangeAccent,
      child: SizedBox(height: 100, width: double.infinity),
    );
  }
}

class BoxWithNestedHero extends StatelessWidget {
  const BoxWithNestedHero({super.key, required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 200,
        width: 200,
        child: active
            ? null
            : MaterialHero(
                tag: 'animals',
                child: const AardvarkBox(),
              ),
      ),
    );
  }
}

class AardvarkBox extends StatelessWidget {
  const AardvarkBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        color: Colors.green,
        child: const Text('Aardvark'),
      ),
    );
  }
}

class BeaverBox extends StatelessWidget {
  const BeaverBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 100,
        height: 25,
        color: Colors.green,
        child: const Text('Beaver'),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final void Function() removeGoal;

  const GoalCard({super.key, required this.removeGoal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.back_hand),
          onPressed: removeGoal,
        ),
      ),
    );
  }
}
