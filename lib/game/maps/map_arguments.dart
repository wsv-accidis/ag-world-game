import 'package:bonfire/bonfire.dart';
import 'package:world/game/maps/maps.dart';

class MapArguments {
  final Maps destMap;
  final Vector2 destPos;
  final Direction direction;

  MapArguments(this.destMap, this.direction, this.destPos);

  // This sets the default player spawn map and position
  static Maps initialMap = Maps.west1;
  static MapArguments defaultArgs() => MapArguments(initialMap, Direction.down, Vector2(1900, 900));

  static MapArguments fromMapSensorParams(Map<String, dynamic> params) {
    // These are custom properties on the 'exitMap' sensors in the map
    // All four must be present, otherwise the transition is broken and there is a bug in the map
    if (!params.containsKey('dest') ||
        !params.containsKey('direction') ||
        !params.containsKey('x') ||
        !params.containsKey('y')) {
      throw ArgumentError("Map sensor is missing required properties.");
    }

    final dest = Maps.fromName(params['dest']);
    final direction = Direction.fromName(params['direction']);
    final positionX = params['x'] as int;
    final positionY = params['y'] as int;
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
