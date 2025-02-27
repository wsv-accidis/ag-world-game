import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart' show GlobalKey;
import 'package:world/game/menu/menu_overlay.dart';
import 'package:world/game/player/the_player_assets.dart';
import 'package:world/util/global_key_extension.dart';

class ThePlayer extends SimplePlayer with BlockMovementCollision, PathFinding, TapGesture {
  ThePlayer(Vector2 position, Direction direction, this.menuKey)
      : super(
            position: position,
            initDirection: direction,
            size: Vector2.all(64),
            speed: 160.0,
            animation: ThePlayerAssets.animation);

  final GlobalKey<MenuOverlayState> menuKey;

  // Player sprite hitbox
  static final _playerHitbox = RectangleHitbox(size: Vector2(28, 48), position: Vector2(18, 14));

  // State for pathfinding
  var _pathFindingLastPos = Vector2.zero();
  var _pathFindingLastTime = 0;
  static const _pathFindingMinDelay = 1000;

  @override
  void onBlockedMovement(PositionComponent other, CollisionData collisionData) {
    // moveToPositionWithPathFinding tends to get stuck on things, stop moving to reset the walking animation
    stopMove();
    super.onBlockedMovement(other, collisionData);
  }

  @override
  Future<void> onLoad() {
    add(_playerHitbox);
    setupPathFinding(linePathEnabled: false, showBarriersCalculated: false, withDiagonal: false);
    return super.onLoad();
  }

  @override
  void onTap() {}

  @override
  void onTapDownScreen(GestureEvent event) {
    // Supress taps that hit the menu
    if (menuKey.globalPaintBounds?.containsPoint(event.screenPosition) ?? false) {
      return;
    }

    // Suppress repeated taps on same position since this creates jank
    var moveToPosition = Vector2(event.worldPosition.x.roundToDouble(), event.worldPosition.y.roundToDouble());
    var now = DateTime.now().millisecondsSinceEpoch;
    if (moveToPosition != _pathFindingLastPos || now - _pathFindingLastTime > _pathFindingMinDelay) {
      _pathFindingLastPos = moveToPosition;
      _pathFindingLastTime = now;

      // Works ok but sometimes gets stuck, change settings in onLoad to debug
      moveToPositionWithPathFinding(moveToPosition);
    }
    super.onTapDownScreen(event);
  }
}
