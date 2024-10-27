import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

class ZoomController extends GameComponent {
  static double getZoom(BuildContext context) =>
      getZoomFromMaxVisibleTile(context, 32, 20);

  @override
  void onGameResize(Vector2 size) {
    gameRef.camera.zoom = getZoom(context);
    super.onGameResize(size);
  }
}
