import 'package:flutter/material.dart';
import '../rendering/controller.dart';
import '../rendering/tracker.dart';
import 'card_hero.dart';
import 'card_hero_layer.dart';
import 'shuttle_wrapper.dart';

// ignore_for_file: public_member_api_docs

/// A widget under which you can create [CardHero] widgets.
class CardHeroScope extends StatefulWidget {
  /// Creates a [CardHeroScope].
  /// All container transform animations under this widget, will have the specified
  /// [duration], [curve], and [createRectTween].
  const CardHeroScope({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
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
  CardHeroScopeState createState() => CardHeroScopeState();
}

class CardHeroScopeState extends State<CardHeroScope> with TickerProviderStateMixin {
  final Map<Object, CardHeroTracker> trackers = <Object, CardHeroTracker>{};

  CardHeroController track(BuildContext context, CardHero cardHero) {
    CardHeroTracker? tracker = trackers[cardHero.tag];
    if (tracker == null) {
      tracker = createTracker(context, cardHero);
      trackers[cardHero.tag] = tracker;
    } else {
      updateTracker(context, cardHero, tracker);
    }
    tracker.count++;
    return tracker.controller;
  }

  CardHeroTracker createTracker(BuildContext context, CardHero cardHero) {
    final CardHeroController controller = CardHeroController(
      duration: widget.duration,
      createRectTween: widget.createRectTween,
      curve: widget.curve,
      tag: cardHero.tag,
      vsync: this,
    );
    final ShuttleBuilder? shuttleBuilder = cardHero.shuttleBuilder;

    final Widget shuttle = (shuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: shuttleBuilder,
            type: ShuttleType.from,
            child: cardHero.child,
          )
        : cardHero.child;

    final OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return CardHeroFollower(
        controller: controller,
        from: shuttle,
        to: shuttle,
        fromCardHero: cardHero,
        toCardHero: cardHero,
      );
    });

    final CardHeroTracker tracker = CardHeroTracker(
      controller: controller,
      overlayEntry: overlayEntry,
      lastCardHero: cardHero,
    );

    tracker.addOverlay(context);
    return tracker;
  }

  void updateTracker(BuildContext context, CardHero cardHero, CardHeroTracker tracker) {
    final CardHero lastCardHero = tracker.lastCardHero;
    final CardHeroController controller = tracker.controller;
    final ShuttleBuilder? fromShuttleBuilder = lastCardHero.shuttleBuilder;
    final ShuttleBuilder? toShuttleBuilder = cardHero.shuttleBuilder;
    final Widget fromShuttle = (fromShuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: fromShuttleBuilder,
            type: ShuttleType.from,
            child: lastCardHero.child,
          )
        : lastCardHero.child;
    final Widget toShuttle = (toShuttleBuilder != null)
        ? ShuttleWrapper(
            animation: controller.view,
            controller: controller,
            shuttleBuilder: toShuttleBuilder,
            type: ShuttleType.to,
            child: cardHero.child,
          )
        : cardHero.child;

    controller.removeListeners();

    final OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return CardHeroFollower(
        controller: controller,
        from: fromShuttle,
        to: toShuttle,
        fromCardHero: lastCardHero,
        toCardHero: cardHero,
      );
    });

    tracker.removeOverlay();
    tracker.overlayEntry = overlayEntry;
    tracker.addOverlay(context);
    tracker.lastCardHero = cardHero;
  }

  void untrack(CardHero cardHero) {
    final CardHeroTracker? tracker = trackers[cardHero.tag];
    if (tracker != null) {
      tracker.count--;
      if (tracker.count == 0) {
        trackers.remove(cardHero.tag);
        disposeTracker(tracker);
      }
    }
  }

  @override
  void dispose() {
    trackers.values.forEach(disposeTracker);
    super.dispose();
  }

  void disposeTracker(CardHeroTracker tracker) {
    tracker.controller.dispose();
    tracker.removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCardHeroScopeState(
      state: this,
      child: widget.child,
    );
  }
}

/// Whether the shuttle is animating [to] or [from] the CardHero widget.
enum ShuttleType {
  /// The shuttle is animating with this CardHero as a starting point.
  from,

  /// The shuttle is animating with this CardHero as an ending point.
  to,
}

class _InheritedCardHeroScopeState extends InheritedWidget {
  const _InheritedCardHeroScopeState({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final CardHeroScopeState state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension BuildContextExtensions on BuildContext {
  T? getInheritedWidget<T extends InheritedWidget>() {
    final InheritedElement? elem = getElementForInheritedWidgetOfExactType<T>();
    return elem?.widget as T?;
  }

  CardHeroScopeState? getCardHeroScopeState() {
    final inheritedState = getInheritedWidget<_InheritedCardHeroScopeState>();
    return inheritedState?.state;
  }
}

RectTween _defaultCreateTweenRect(Rect? begin, Rect? end) {
  return MaterialRectArcTween(begin: begin, end: end);
}
