import 'package:bonfire/bonfire.dart';
import 'package:world/game/maps/map_arguments.dart';
import 'package:world/game/maps/maps.dart';

class ExitMapSensor extends GameDecoration with Sensor<Player> {
  ExitMapSensor(Vector2 position, Vector2 size, this._srcMap, this._destMap) : super(position: position, size: size);

  bool _contacted = false;
  final Maps _destMap;
  final Maps _srcMap;

  @override
  void onContact(Player component) {
    if (_contacted) return;
    _contacted = true;

    MapNavigator.of(context).toNamed(_destMap.name, arguments: MapArguments.fromSrcDestMap(_srcMap, _destMap));
  }
}
