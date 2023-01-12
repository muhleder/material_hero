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
  bool active = false;

  void getStarted() {
    active = !active;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialHeroScope(
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Container(
              color: Colors.yellowAccent,
              child: Stack(
                children: [
                  Positioned(top: 0, left: 0, child: Text('Active is $active')),
                  if (!active)
                    Positioned(
                      top: 27,
                      left: 103,
                      child: MaterialHero(
                        // enabled: false,
                        key: const ValueKey('orange_box'),
                        tag: 'promo',
                        shuttleBuilder: (context, child, value, _, __) => Container(),
                        color: Colors.orangeAccent,
                        child: DayPromo(active: active, getStarted: getStarted),
                      ),
                    ),
                  if (active)
                    Positioned(
                        top: 300,
                        left: 300,
                        child: MaterialHero(
                          key: const ValueKey('purple'),
                          tag: 'promo',
                          color: Colors.deepPurpleAccent,
                          shuttleBuilder: (context, child, value, _, __) => Container(),
                          child: const SizedBox(width: 100, height: 100, child: Text('Hello')),
                        )),
                  if (active)
                    Positioned(
                      top: 300,
                      left: 103,
                      child: MaterialHero(
                          tag: 'new_goal',
                          key: const ValueKey('end_button'),
                          // enabled: false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 100,
                              height: 50,
                              color: Colors.blue,
                              child: GestureDetector(
                                onTap: getStarted,
                                child: const Text('close'),
                              ),
                            ),
                          )),
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

class DayPromo extends StatelessWidget {
  const DayPromo({super.key, required this.active, required this.getStarted});
  final bool active;
  final void Function() getStarted;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 200,
        width: 200,
        // child: StartButton(getStarted: getStarted),
        child: active
            ? null
            : MaterialHero(
                tag: 'new_goal',
                key: const ValueKey('start_button'),
                child: StartButton(getStarted: getStarted),
              ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
    required this.getStarted,
  });

  final void Function() getStarted;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 100,
        height: 50,
        color: Colors.green,
        child: GestureDetector(
          onTap: getStarted,
          child: const Text('open'),
        ),
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
