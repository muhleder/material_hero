import 'package:flutter/material.dart';

import 'card_hero.dart';

class CardDecoration extends StatelessWidget {
  const CardDecoration({
    super.key,
    required this.color,
    required this.elevation,
    required this.child,
    required this.shape,
    this.animationValue,
  });
  final Color color;
  final double elevation;
  final Widget? child;
  final ShapeBorder shape;
  final double? animationValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(animationValue),
      shape: shape,
      color: color,
      elevation: elevation,
      child: child,
    );
  }
}

class CardDecorationAnimator extends StatelessWidget {
  CardDecorationAnimator({
    super.key,
    required this.animation,
    required this.fromHero,
    required this.toHero,
    required this.from,
    required this.to,
  })  : colorTween = ColorTween(end: toHero.color, begin: fromHero.color),
        elevationTween = Tween<double>(begin: fromHero.elevation, end: toHero.elevation),
        shapeTween = ShapeBorderTween(begin: fromHero.shape, end: toHero.shape);
  final Animation<double> animation;
  final CardHero fromHero;
  final CardHero toHero;
  final Widget from;
  final Widget to;
  final ColorTween colorTween;
  final ShapeBorderTween shapeTween;
  final Tween<double> elevationTween;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: Stack(
          fit: StackFit.expand,
          children: [to, from],
        ),
        builder: (context, child) {
          return CardDecoration(
            color: colorTween.evaluate(animation) ?? Colors.transparent,
            elevation: elevationTween.evaluate(animation),
            shape: shapeTween.evaluate(animation) ?? const RoundedRectangleBorder(),
            animationValue: animation.value,
            child: child,
          );
        });
  }
}
