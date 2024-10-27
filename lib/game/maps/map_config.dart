import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/builder/tiled_world_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:world/game/maps/exit_map_sensor.dart';
import 'package:world/game/maps/show_menu_sensor.dart';
import 'package:world/game/menu/menu_overlay.dart';

enum Maps { west0, west1, west2 }

class MapConfig {
  MapConfig(this._menuKey);

  final GlobalKey<MenuOverlayState> _menuKey;

  Map<String, MapItem Function(BuildContext, Object?)> get maps =>
      {for (var item in Maps.values) item.name: (context, args) => _map(item.name)};

  MapItem _map(String name) => MapItem(
      id: name,
      map: WorldMapByTiled(WorldMapReader.fromAsset('tiled/map-$name.json'), objectsBuilder: _objectsBuilder));

  Map<String, ObjectBuilder> get _objectsBuilder => {
        'exitMap': (params) => ExitMapSensor(params.position, params.size, params.others['dest']),
        'showMenu': (params) => ShowMenuSensor(params.position, params.size, _menuKey, true)
      };
}
