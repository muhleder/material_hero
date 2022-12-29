import 'package:flutter/widgets.dart';

import 'card_hero.dart';
import 'card_hero_scope.dart';

class ShuttleWrapper extends StatefulWidget {
  const ShuttleWrapper({
    super.key,
    required this.animation,
    required this.shuttleBuilder,
    required this.type,
    required this.child,
  });
  final Animation<double> animation;
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
    return widget.shuttleBuilder(context, widget.child, animationValue);
  }
}
