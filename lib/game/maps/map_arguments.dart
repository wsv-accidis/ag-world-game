import 'package:bonfire/bonfire.dart';
import 'package:world/game/maps/maps.dart';

class MapArguments {
  final Maps destMap;
  final Vector2 destPos;
  final Direction direction;

  MapArguments(this.destMap, this.direction, this.destPos);

  // This sets the default player spawn map and position
  static MapArguments defaultArgs() => MapArguments(Maps.west0, Direction.down, Vector2(2350, 560));

  static MapArguments fromMapSensorParams(Map<String, dynamic> params) {
    final dest = Maps.fromName(params['dest'] ?? '');
    final direction = Direction.fromName(params['direction'] ?? '');
    final positionX = params['x'] as int? ?? 0;
    final positionY = params['y'] as int? ?? 0;
    return MapArguments(dest, direction, Vector2(positionX.toDouble(), positionY.toDouble()));
  }

  MapArguments withSourcePosition(Vector2 srcPos) =>
      // On vertical transition: Retain y position, offset x position according to where player exited source map
      // On horizontal transition: Opposite of above

      switch (direction) {
        Direction.up || Direction.down => MapArguments(destMap, direction, Vector2(srcPos.x + destPos.x, destPos.y)),
        Direction.left || Direction.right => MapArguments(destMap, direction, Vector2(destPos.x, srcPos.y + destPos.y)),
        _ => throw ArgumentError("Invalid direction $direction for map arguments.")
      };
}
