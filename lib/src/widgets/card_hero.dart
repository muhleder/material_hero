import 'package:flutter/material.dart';
import '../rendering/controller.dart';
import 'card_hero_layer.dart';
import 'card_hero_scope.dart';
import 'card_decoration.dart';

/// Simplified shuttle builder, passed the child of the LocalHero, an animation
/// value which animates from 0 to 1 through the transition, and the animation controller.
typedef ShuttleBuilder = Widget Function(BuildContext context, Widget child, double value, CardHeroController controller);

/// Mark its child as a candidate for container transform animation.
///
/// When the position of this widget (from the perspective of Flutter) changes,
/// an animation is started from the previous position to the new one.
///
/// You'll have to use a [Key] in the top most parent in your container in order
/// to explicitly tell the framework to preserve the state of your children.
class CardHero extends StatefulWidget {
  /// Creates a [CardHero].
  ///
  /// If between two frames, the position of a [CardHero] with the same tag
  /// changes, a container transform animation will be triggered.
  const CardHero({
    Key? key,
    required this.tag,
    this.shuttleBuilder,
    this.enabled = true,
    required this.child,
    this.shape = const RoundedRectangleBorder(),
    this.color = Colors.transparent,
    this.elevation = 0,
  }) : super(key: key);

  /// The identifier for this particular container transform. This tag must be unique
  /// under the same [CardHeroScope].
  /// If between two frames, the position of a [CardHero] with the same tag
  /// changes, a container transform animation will be triggered.
  final Object tag;

  /// Builder to provide the animation of the content during transition.
  final ShuttleBuilder? shuttleBuilder;

  final Color color;

  final ShapeBorder shape;

  final double elevation;

  /// Whether the hero animation should be enabled.
  final bool enabled;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  CardHeroState createState() => CardHeroState();
}

class CardHeroState extends State<CardHero> with SingleTickerProviderStateMixin<CardHero> {
  CardHeroController? controller;
  CardHeroScopeState? scopeState;

  @override
  void initState() {
    scopeState = context.getCardHeroScopeState();
    controller = scopeState?.track(context, widget);
    super.initState();
  }

  @override
  void dispose() {
    scopeState?.untrack(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CardHeroController? controller = this.controller;
    // If the CardHero itself is in an overlay then there will be no parent LocalHeroScope and no controller.
    return widget.enabled && controller != null
        ? CardHeroLeader(
            controller: controller,
            child: CardDecoration(
              color: widget.color,
              elevation: widget.elevation,
              shape: widget.shape,
              child: widget.child,
            ),
          )
        : CardDecoration(
            color: widget.color,
            elevation: widget.elevation,
            shape: widget.shape,
            child: widget.child,
          );
  }
}
