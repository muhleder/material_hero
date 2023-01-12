import 'package:flutter/widgets.dart';

import '../rendering/controller.dart';
import 'material_hero.dart';
import 'material_hero_scope.dart';

class ShuttleWrapper extends StatefulWidget {
  const ShuttleWrapper({
    super.key,
    required this.animation,
    required this.shuttleBuilder,
    required this.type,
    required this.child,
    required this.controller,
  });
  final Animation<double> animation;
  final MaterialHeroController controller;
  final ShuttleType type;
  final ShuttleBuilder shuttleBuilder;
  final Widget child;

  @override
  State<ShuttleWrapper> createState() => _ShuttleWrapperState();
}

class _ShuttleWrapperState extends State<ShuttleWrapper> {
  @override
  void initState() {
    animationValue = _calculateAnimationValue(widget.type, widget.animation);
    widget.animation.addListener(_animationChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.animation.removeListener(_animationChanged);
    super.dispose();
  }

  void _animationChanged() {
    animationValue = _calculateAnimationValue(widget.type, widget.animation);
    setState(() {});
  }

  static double _calculateAnimationValue(ShuttleType type, Animation<double> animation) {
    double animationValue;
    if (type == ShuttleType.to) {
      animationValue = animation.value;
    } else {
      animationValue = 1 - animation.value;
    }
    return animationValue;
  }

  double animationValue = 0;

  @override
  Widget build(BuildContext context) {
    return widget.shuttleBuilder(context, widget.child, animationValue, widget.controller, widget.type);
  }
}
