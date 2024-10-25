import 'package:bonfire/bonfire.dart';

class ZoomController extends GameComponent {
  @override
  void onGameResize(Vector2 size) {
    gameRef.camera.zoom = getZoomFromMaxVisibleTile(context, 32, 20);
    super.onGameResize(size);
  }
}
