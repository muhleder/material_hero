import 'package:flutter/widgets.dart';

import 'card_hero.dart';
import 'card_decoration.dart';
import '../rendering/controller.dart';
import '../rendering/card_hero_layer.dart';

// ignore_for_file: public_member_api_docs

class CardHeroFollower extends SingleChildRenderObjectWidget {
  CardHeroFollower({
    Key? key,
    required this.controller,
    required Widget from,
    required Widget to,
    required CardHero fromCardHero,
    required CardHero toCardHero,
  }) : super(
            key: key,
            child: CardDecorationAnimator(
              animation: controller.view,
              from: from,
              fromHero: fromCardHero,
              to: to,
              toHero: toCardHero,
            ));

  final CardHeroController controller;

  @override
  CardHeroFollowerElement createElement() {
    return CardHeroFollowerElement(this);
  }

  @override
  RenderCardHeroFollowerLayer createRenderObject(BuildContext context) {
    return RenderCardHeroFollowerLayer(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCardHeroFollowerLayer renderObject,
  ) {
    renderObject.controller = controller;
  }
}

class CardHeroFollowerElement extends SingleChildRenderObjectElement {
  CardHeroFollowerElement(CardHeroFollower widget) : super(widget);

  @override
  CardHeroFollower get widget => super.widget as CardHeroFollower;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (widget.controller.isAnimating) {
      super.debugVisitOnstageChildren(visitor);
    }
  }
}

class CardHeroLeader extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// The [link] property must not be null, and must not be currently being used
  /// by any other [CompositedTransformTarget] object that is in the tree.
  const CardHeroLeader({
    Key? key,
    required this.controller,
    Widget? child,
  }) : super(key: key, child: child);

  final CardHeroController controller;

  @override
  CardHeroLeaderElement createElement() {
    return CardHeroLeaderElement(this);
  }

  @override
  RenderCardHeroLeaderLayer createRenderObject(BuildContext context) {
    return RenderCardHeroLeaderLayer(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCardHeroLeaderLayer renderObject,
  ) {
    renderObject.controller = controller;
  }
}

class CardHeroLeaderElement extends SingleChildRenderObjectElement {
  CardHeroLeaderElement(CardHeroLeader widget) : super(widget);

  @override
  CardHeroLeader get widget => super.widget as CardHeroLeader;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (!widget.controller.isAnimating) {
      super.debugVisitOnstageChildren(visitor);
    }
  }
}
