import 'package:bonfire/bonfire.dart';

class ExitMapSensor extends GameDecoration with Sensor<Player> {
  ExitMapSensor(Vector2 position, Vector2 size, this._destMap) : super(position: position, size: size);

  bool _contacted = false;
  final String _destMap;

  @override
  void onContact(Player component) {
    if (_contacted) return;
    _contacted = true;

    MapNavigator.of(context).toNamed(_destMap);
  }
}
