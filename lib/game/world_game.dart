import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:world/game/maps/map_arguments.dart';
import 'package:world/game/maps/map_config.dart';
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
    final mapConfig = MapConfig(menuKey);

    return MapNavigator(
        maps: mapConfig.maps,
        builder: (context, arguments, map) {
          final args = arguments as MapArguments?;

          return BonfireWidget(
              backgroundColor: const Color.fromRGBO(7, 67, 55, 1.0),
              cameraConfig: CameraConfig(moveOnlyMapArea: true, zoom: ZoomController.getZoom(context)),
              components: [ZoomController()],
              initialActiveOverlays: const [MenuOverlay.overlayKey],
              map: map.map,
              overlayBuilderMap: {
                MenuOverlay.overlayKey: (buildContext, game) => MenuOverlay(key: menuKey, game: game),
              },
              player: ThePlayer(
                  args?.playerPosition ?? _playerSpawnPoint, args?.playerDirection ?? Direction.down, menuKey),
              playerControllers: [
                Keyboard(
                    config: KeyboardConfig(
                  acceptedKeys: [],
                  directionalKeys: [KeyboardDirectionalKeys.arrows()],
                )),
              ],
              showCollisionArea: false);
        });
  }
}
