import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/builder/tiled_world_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:world/game/maps/exit_map_sensor.dart';
import 'package:world/game/maps/maps.dart';
import 'package:world/game/maps/show_menu_sensor.dart';
import 'package:world/game/menu/menu_overlay.dart';

class MapConfig {
  MapConfig(this._menuKey);

  final GlobalKey<MenuOverlayState> _menuKey;

  Map<String, MapItem Function(BuildContext, Object?)> get maps =>
      {for (var item in Maps.values) item.name: (context, args) => _map(item.name)};

  MapItem _map(String id) => MapItem(
      id: id,
      map: WorldMapByTiled(WorldMapReader.fromAsset('tiled/map-$id.json'), objectsBuilder: _objectsBuilder(id)));

  Map<String, ObjectBuilder> _objectsBuilder(String id) => {
        'exitMap': (params) =>
            ExitMapSensor(params.position, params.size, Maps.fromName(id), Maps.fromName(params.others['dest'])),
        'showMenu': (params) => ShowMenuSensor(params.position, params.size, _menuKey, true)
      };
}
