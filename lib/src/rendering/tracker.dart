import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../widgets/material_hero.dart';
import '../widgets/material_hero_layer.dart';
import '../widgets/material_decoration.dart';
import 'controller.dart';

class MaterialHeroTracker {
  MaterialHeroTracker({
    required this.overlayEntry,
    required this.controller,
    required this.lastMaterialHero,
  }) {
    controller.animationStatusStream.listen(_onAnimationStatusChange);
  }

  OverlayEntry overlayEntry;
  OverlayState? overlayState;
  final MaterialHeroController controller;
  MaterialHeroWithContext lastMaterialHero;
  int count = 0;

  bool _removeRequested = false;
  bool _overlayInserted = false;

  void addOverlay(BuildContext context) {
    overlayState = Overlay.of(context);
    _removeRequested = false;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_removeRequested) {
        overlayState?.insert(overlayEntry);
        _overlayInserted = true;
      }
    });
  }

  void removeOverlay() {
    _removeRequested = true;
    if (_overlayInserted) {
      overlayEntry.remove();
      _overlayInserted = false;
    }
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    // On completion, we place a copy of the final child widget into the overlay,
    // otherwise if we animate agin we get a one frame flash where there is nothing
    // in the overlay, and the widget has been removed.
    if (status == AnimationStatus.completed) {
      removeOverlay();
      final OverlayEntry childEntry = OverlayEntry(builder: (context) {
        return MaterialHeroFollower(
          controller: controller,
          from: lastMaterialHero.child,
          fromMaterialHero: lastMaterialHero,
          toMaterialHero: lastMaterialHero,
          to: MaterialDecoration(
            color: lastMaterialHero.color,
            elevation: lastMaterialHero.elevation,
            shape: lastMaterialHero.shapeBorder,
            child: lastMaterialHero.child,
          ),
        );
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        overlayEntry = childEntry;
        overlayState?.insert(childEntry);
        _overlayInserted = true;
      });
    }
  }
}
