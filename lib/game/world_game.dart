import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:world/game/menu_overlay.dart';
import 'package:world/game/the_player.dart';
import 'package:world/game/zoom_controller.dart';

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
        cameraConfig: CameraConfig(moveOnlyMapArea: true),
        components: [ZoomController()],
        initialActiveOverlays: const [MenuOverlay.overlayKey],
        map: WorldMapByTiled(WorldMapReader.fromAsset('tiled/map-west0.json')),
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
