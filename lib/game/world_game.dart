import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:world/game/maps/exit_map_sensor.dart';
import 'package:world/game/maps/show_menu_sensor.dart';
import 'package:world/game/menu/menu_overlay.dart';
import 'package:world/game/misc/zoom_controller.dart';
import 'package:world/game/player/the_player.dart';

class WorldGame extends StatefulWidget {
  const WorldGame({super.key, required this.title});

  final String title;

  @override
  State<WorldGame> createState() => _WorldGameState();
}

class _WorldGameState extends State<WorldGame> {
  static final _playerSpawnPoint = Vector2(800, 1000);

  @override
  Widget build(BuildContext context) {
    final menuKey = GlobalKey<MenuOverlayState>();

    return BonfireWidget(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1.0),
        cameraConfig: CameraConfig(moveOnlyMapArea: true, zoom: ZoomController.getZoom(context)),
        components: [ZoomController()],
        initialActiveOverlays: const [MenuOverlay.overlayKey],
        map: WorldMapByTiled(WorldMapReader.fromAsset('tiled/map-west0.json'), objectsBuilder: {
          'exitMap': (params) => ExitMapSensor(params.position, params.size, params.others['dest']),
          'showMenu': (params) => ShowMenuSensor(params.position, params.size, menuKey, true)
        }),
        overlayBuilderMap: {
          MenuOverlay.overlayKey: (buildContext, game) => MenuOverlay(key: menuKey, game: game),
        },
        player: ThePlayer(_playerSpawnPoint, menuKey),
        playerControllers: [
          Keyboard(
              config: KeyboardConfig(
            acceptedKeys: [],
            directionalKeys: [KeyboardDirectionalKeys.arrows()],
          )),
        ],
        showCollisionArea: false);
  }
}
