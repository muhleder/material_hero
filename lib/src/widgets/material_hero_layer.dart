import 'package:flutter/widgets.dart';

import 'material_hero.dart';
import 'material_decoration.dart';
import '../rendering/controller.dart';
import '../rendering/material_hero_layer.dart';

// ignore_for_file: public_member_api_docs

class MaterialHeroFollower extends SingleChildRenderObjectWidget {
  MaterialHeroFollower({
    Key? key,
    required this.controller,
    required Widget from,
    required Widget to,
    required MaterialHeroWithContext fromMaterialHero,
    required MaterialHeroWithContext toMaterialHero,
  }) : super(
            key: key,
            child: MaterialDecorationAnimator(
              animation: controller.view,
              from: from,
              fromHero: fromMaterialHero,
              to: to,
              toHero: toMaterialHero,
            ));

  final MaterialHeroController controller;

  @override
  MaterialHeroFollowerElement createElement() {
    return MaterialHeroFollowerElement(this);
  }

  @override
  RenderMaterialHeroFollowerLayer createRenderObject(BuildContext context) {
    return RenderMaterialHeroFollowerLayer(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderMaterialHeroFollowerLayer renderObject,
  ) {
    renderObject.controller = controller;
  }
}

class MaterialHeroFollowerElement extends SingleChildRenderObjectElement {
  MaterialHeroFollowerElement(MaterialHeroFollower widget) : super(widget);

  @override
  MaterialHeroFollower get widget => super.widget as MaterialHeroFollower;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (widget.controller.isAnimating) {
      super.debugVisitOnstageChildren(visitor);
    }
  }
}

class MaterialHeroLeader extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// The [link] property must not be null, and must not be currently being used
  /// by any other [CompositedTransformTarget] object that is in the tree.
  const MaterialHeroLeader({
    Key? key,
    required this.controller,
    Widget? child,
  }) : super(key: key, child: child);

  final MaterialHeroController controller;

  @override
  MaterialHeroLeaderElement createElement() {
    return MaterialHeroLeaderElement(this);
  }

  @override
  RenderMaterialHeroLeaderLayer createRenderObject(BuildContext context) {
    return RenderMaterialHeroLeaderLayer(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderMaterialHeroLeaderLayer renderObject,
  ) {
    renderObject.controller = controller;
  }
}

class MaterialHeroLeaderElement extends SingleChildRenderObjectElement {
  MaterialHeroLeaderElement(MaterialHeroLeader widget) : super(widget);

  @override
  MaterialHeroLeader get widget => super.widget as MaterialHeroLeader;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (!widget.controller.isAnimating) {
      super.debugVisitOnstageChildren(visitor);
    }
  }
}
