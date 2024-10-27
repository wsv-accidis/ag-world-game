import 'package:bonfire/bonfire.dart';
import 'package:world/game/maps/maps.dart';

class MapArguments {
  final Vector2 playerPosition;
  final Direction playerDirection;

  MapArguments(this.playerPosition, this.playerDirection);

  static MapArguments fromSrcDestMap(Maps src, Maps dest) {
    switch (src) {
      case Maps.west0:
        // west0 borders west1 and west2
        switch (dest) {
          case Maps.west1:
            return MapArguments(Vector2(120, 1450), Direction.right);
          case Maps.west2:
            return MapArguments(Vector2(120, 500), Direction.right);
          default:
            throw Exception("Unknown transition $src -> $dest.");
        }

      case Maps.west1:
        // west1 borders west0 and west2 and ...
        switch (dest) {
          case Maps.west0:
            return MapArguments(Vector2(2250, 420), Direction.left);
          case Maps.west2:
            return MapArguments(Vector2(1250, 150), Direction.down);
          default:
            throw Exception("Unknown transition $src -> $dest.");
        }

      case Maps.west2:
        // west2 borders west0 and west1 and ...
        switch (dest) {
          case Maps.west0:
            return MapArguments(Vector2(2250, 1200), Direction.left);
          case Maps.west1:
            return MapArguments(Vector2(1250, 1600), Direction.up);
          default:
            throw Exception("Unknown transition $src -> $dest.");
        }
    }
  }
}
