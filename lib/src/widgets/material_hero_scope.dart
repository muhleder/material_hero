import 'package:flutter/material.dart';
import '../rendering/controller.dart';
import '../rendering/tracker.dart';
import 'material_hero.dart';
import 'material_hero_layer.dart';
import 'shuttle_wrapper.dart';

// ignore_for_file: public_member_api_docs

/// A widget under which you can create [MaterialHero] widgets.
class MaterialHeroScope extends StatefulWidget {
  /// Creates a [MaterialHeroScope].
  /// All container transform animations under this widget, will have the specified
  /// [duration], [curve], and [createRectTween].
  const MaterialHeroScope({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.createRectTween = _defaultCreateTweenRect,
    required this.child,
  }) : super(key: key);

  /// The duration of the animation.
  final Duration duration;

  /// The curve for the hero animation.
  final Curve curve;

  /// Defines how the destination hero's bounds change as it flies from the
  /// starting position to the destination position.
  ///
  /// The default value creates a [MaterialRectArcTween].
  final CreateRectTween createRectTween;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  MaterialHeroScopeState createState() => MaterialHeroScopeState();
}

class MaterialHeroScopeState extends State<MaterialHeroScope> with TickerProviderStateMixin {
  final Map<Object, MaterialHeroTracker> trackers = <Object, MaterialHeroTracker>{};

  MaterialHeroController track(BuildContext context, MaterialHeroWithContext materialHero) {
    MaterialHeroTracker? tracker = trackers[materialHero.tag];
    if (tracker == null) {
      tracker = createTracker(context, materialHero);
      trackers[materialHero.tag] = tracker;
    } else {
      updateTracker(context, materialHero, tracker);
    }
    tracker.count++;
    return tracker.controller;
  }

  MaterialHeroTracker createTracker(BuildContext context, MaterialHeroWithContext materialHero) {
    final MaterialHeroController controller = MaterialHeroController(
      duration: widget.duration,
      createRectTween: widget.createRectTween,
      curve: widget.curve,
      tag: materialHero.tag,
      vsync: this,
    );
    final ShuttleBuilder? shuttleBuilder = materialHero.shuttleBuilder;

    final Widget shuttle = (shuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: shuttleBuilder,
            type: ShuttleType.from,
            child: materialHero.child,
          )
        : materialHero.child;

    final OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return MaterialHeroFollower(
        controller: controller,
        from: shuttle,
        to: shuttle,
        fromMaterialHero: materialHero,
        toMaterialHero: materialHero,
      );
    });

    final MaterialHeroTracker tracker = MaterialHeroTracker(
      controller: controller,
      overlayEntry: overlayEntry,
      lastMaterialHero: materialHero,
    );

    tracker.addOverlay(context);
    return tracker;
  }

  void updateTracker(BuildContext context, MaterialHeroWithContext materialHero, MaterialHeroTracker tracker) {
    final MaterialHeroWithContext lastMaterialHero = tracker.lastMaterialHero;
    final MaterialHeroController controller = tracker.controller;
    final ShuttleBuilder? fromShuttleBuilder = lastMaterialHero.shuttleBuilder;
    final ShuttleBuilder? toShuttleBuilder = materialHero.shuttleBuilder;
    final Widget fromShuttle = (fromShuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: fromShuttleBuilder,
            type: ShuttleType.from,
            child: lastMaterialHero.child,
          )
        : lastMaterialHero.child;
    final Widget toShuttle = (toShuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: toShuttleBuilder,
            type: ShuttleType.to,
            child: materialHero.child,
          )
        : materialHero.child;

    controller.removeListeners();

    final OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return MaterialHeroFollower(
        controller: controller,
        from: fromShuttle,
        to: toShuttle,
        fromMaterialHero: lastMaterialHero,
        toMaterialHero: materialHero,
      );
    });

    tracker.removeOverlay();
    tracker.overlayEntry = overlayEntry;
    tracker.addOverlay(context);
    tracker.lastMaterialHero = materialHero;
  }

  void untrack(MaterialHeroWithContext materialHero) {
    final MaterialHeroTracker? tracker = trackers[materialHero.tag];
    if (tracker != null) {
      tracker.count--;
      if (tracker.count == 0) {
        trackers.remove(materialHero.tag);
        disposeTracker(tracker);
      }
    }
  }

  @override
  void dispose() {
    trackers.values.forEach(disposeTracker);
    super.dispose();
  }

  void disposeTracker(MaterialHeroTracker tracker) {
    tracker.controller.dispose();
    tracker.removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMaterialHeroScopeState(
      state: this,
      child: widget.child,
    );
  }
}

/// Whether the shuttle is animating [to] or [from] the MaterialHero widget.
enum ShuttleType {
  /// The shuttle is animating with this MaterialHero as a starting point.
  from,

  /// The shuttle is animating with this MaterialHero as an ending point.
  to,
}

class _InheritedMaterialHeroScopeState extends InheritedWidget {
  const _InheritedMaterialHeroScopeState({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final MaterialHeroScopeState state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension BuildContextExtensions on BuildContext {
  T? getInheritedWidget<T extends InheritedWidget>() {
    final InheritedElement? elem = getElementForInheritedWidgetOfExactType<T>();
    return elem?.widget as T?;
  }

  MaterialHeroScopeState? getMaterialHeroScopeState() {
    final inheritedState = getInheritedWidget<_InheritedMaterialHeroScopeState>();
    return inheritedState?.state;
  }
}

RectTween _defaultCreateTweenRect(Rect? begin, Rect? end) {
  return MaterialRectArcTween(begin: begin, end: end);
}
