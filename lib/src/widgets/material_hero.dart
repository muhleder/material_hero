import 'package:flutter/material.dart';
import '../rendering/controller.dart';
import 'material_hero_layer.dart';
import 'material_hero_scope.dart';
import 'material_decoration.dart';

/// Simplified shuttle builder, passed the child of the LocalHero, an animation
/// value which animates from 0 to 1 through the transition, and the animation controller.
typedef ShuttleBuilder = Widget Function(BuildContext context, Widget child, double value, MaterialHeroController controller, ShuttleType type);

/// Mark its child as a candidate for container transform animation.
///
/// When the position of this widget (from the perspective of Flutter) changes,
/// an animation is started from the previous position to the new one.
///
/// You'll have to use a [Key] in the top most parent in your container in order
/// to explicitly tell the framework to preserve the state of your children.
class MaterialHero extends StatefulWidget {
  /// Creates a [MaterialHero].
  ///
  /// If between two frames, the position of a [MaterialHero] with the same tag
  /// changes, a container transform animation will be triggered.
  MaterialHero({
    // key is required otherwise from and to MaterialHeros get mixed up during animation.
    Key? key,
    required this.tag,
    this.shuttleBuilder = fadeThroughShuttleWrapper,
    this.enabled = true,
    required this.child,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.color = Colors.transparent,
    this.elevation = 0,
  }) : super(key: key ?? UniqueKey());

  /// The identifier for this particular container transform. This tag must be unique
  /// under the same [MaterialHeroScope].
  /// If between two frames, the position of a [MaterialHero] with the same tag
  /// changes, a container transform animation will be triggered.
  final Object tag;

  /// Builder to provide the animation of the content during transition.
  final ShuttleBuilder? shuttleBuilder;

  final Color color;

  final ShapeBorder shapeBorder;

  final double elevation;

  /// Whether the hero animation should be enabled.
  final bool enabled;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  MaterialHeroState createState() => MaterialHeroState();
}

class MaterialHeroState extends State<MaterialHero> with SingleTickerProviderStateMixin<MaterialHero> {
  MaterialHeroController? controller;
  MaterialHeroScopeState? scopeState;

  @override
  void initState() {
    scopeState = context.getMaterialHeroScopeState();
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
    MaterialHeroController? controller = this.controller;
    // If the MaterialHero itself is in an overlay then there will be no parent LocalHeroScope and no controller.
    return widget.enabled && controller != null
        ? MaterialHeroLeader(
            controller: controller,
            child: MaterialDecoration(
              color: widget.color,
              elevation: widget.elevation,
              shape: widget.shapeBorder,
              child: widget.child,
            ),
          )
        : MaterialDecoration(
            color: widget.color,
            elevation: widget.elevation,
            shape: widget.shapeBorder,
            child: widget.child,
          );
  }
}

Widget fadeThroughShuttleWrapper(BuildContext context, Widget child, double value, __, _) {
  return FittedBox(
    fit: BoxFit.fitWidth,
    child: Opacity(
      opacity: value,
      child: child,
    ),
  );
}
