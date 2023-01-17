import 'package:flutter/material.dart';
import '../rendering/controller.dart';
import 'material_hero_layer.dart';
import 'material_hero_scope.dart';
import 'material_decoration.dart';

/// Simplified shuttle builder, passed the child of the MaterialHero, an animation
/// value which animates from 0 to 1 through the transition, the animation controller, and the shuttle type.
typedef ShuttleBuilder = Widget Function(BuildContext context, Widget child, double value, MaterialHeroController controller, ShuttleType type);

/// Mark its child as a candidate for container transform animation.
///
/// When the position of this widget (from the perspective of Flutter) changes,
/// an animation is started from the previous position to the new one.
///
/// You'll have to use a [Key] in the top most parent in your container in order
/// to explicitly tell the framework to preserve the state of your children.
class MaterialHero extends StatelessWidget {
  /// Creates a [MaterialHero].
  ///
  /// If between two frames, the position of a [MaterialHero] with the same tag
  /// changes, a container transform animation will be triggered.
  MaterialHero({
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
  Widget build(BuildContext context) {
    return MaterialHeroWithContext(
      key: key,
      tag: tag,
      color: color,
      context: context,
      elevation: elevation,
      enabled: enabled,
      shapeBorder: shapeBorder,
      shuttleBuilder: shuttleBuilder,
      child: child,
    );
  }
}

/// MaterialHeroWithContext is needed so that we can get the theme from the original context.
/// Without the context theme the widget animated in the overlay will use Flutter's default theme.
class MaterialHeroWithContext extends StatefulWidget {
  MaterialHeroWithContext({
    required Key? key,
    required this.tag,
    required this.shuttleBuilder,
    required this.enabled,
    required this.child,
    required BuildContext context,
    required this.shapeBorder,
    required this.color,
    required this.elevation,
  })  : theme = Theme.of(context),
        super(key: key ?? UniqueKey());

  final Object tag;
  final ShuttleBuilder? shuttleBuilder;
  final Color color;
  final ShapeBorder shapeBorder;
  final ThemeData theme;
  final double elevation;
  final bool enabled;
  final Widget child;

  @override
  MaterialHeroWithContextState createState() => MaterialHeroWithContextState();
}

class MaterialHeroWithContextState extends State<MaterialHeroWithContext> with SingleTickerProviderStateMixin<MaterialHeroWithContext> {
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
    // If the MaterialHero itself is in an overlay then there will be no parent MaterialHeroScope and no controller.
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

Widget fadeThroughShuttleWrapper(
  BuildContext context,
  Widget child,
  double value,
  MaterialHeroController controller,
  ShuttleType type,
) {
  Size? fromSize = controller.fromRect?.size;
  Size? toSize = controller.toRect?.size;
  double scaleX;
  double scaleY;
  Size? childSize;
  if (fromSize == null || toSize == null) {
    scaleX = 1;
    scaleY = 1;
  } else {
    double currentWidth = (toSize.width - fromSize.width) * controller.view.value + fromSize.width;
    double currentHeight = (toSize.height - fromSize.height) * controller.view.value + fromSize.height;
    switch (type) {
      case ShuttleType.from:
        scaleX = currentWidth / fromSize.width;
        scaleY = currentHeight / fromSize.height;
        childSize = fromSize;
        break;
      case ShuttleType.to:
        scaleX = currentWidth / toSize.width;
        scaleY = currentHeight / toSize.height;
        childSize = toSize;
        break;
    }
  }
  // This isn't quite right, but is reasonably close.
  return Transform.scale(
    scaleX: scaleX,
    scaleY: scaleY,
    child: Opacity(
      opacity: value,
      child: Center(
        child: SizedBox(
          width: childSize?.width,
          height: childSize?.height,
          child: child,
        ),
      ),
    ),
  );
}
