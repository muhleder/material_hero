import 'package:flutter/material.dart';

import 'material_hero.dart';

class MaterialDecoration extends StatelessWidget {
  const MaterialDecoration({
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
    return Material(
      type: MaterialType.card,
      key: ValueKey(animationValue), // key is needed or elevation property does not update during.
      shape: shape,
      color: color,
      elevation: elevation,
      child: child,
    );
  }
}

class MaterialDecorationAnimator extends StatelessWidget {
  MaterialDecorationAnimator({
    super.key,
    required this.animation,
    required this.fromHero,
    required this.toHero,
    required this.from,
    required this.to,
  })  : colorTween = ColorTween(end: toHero.color, begin: fromHero.color),
        elevationTween = Tween<double>(begin: fromHero.elevation, end: toHero.elevation),
        shapeBorderTween = ShapeBorderTween(begin: fromHero.shapeBorder, end: toHero.shapeBorder);
  final Animation<double> animation;
  final MaterialHero fromHero;
  final MaterialHero toHero;
  final Widget from;
  final Widget to;
  final ColorTween colorTween;
  final ShapeBorderTween shapeBorderTween;
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
          return MaterialDecoration(
            color: colorTween.evaluate(animation) ?? Colors.transparent,
            elevation: elevationTween.evaluate(animation),
            shape: shapeBorderTween.evaluate(animation) ?? const RoundedRectangleBorder(),
            animationValue: animation.value,
            child: child,
          );
        });
  }
}
