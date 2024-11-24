import 'package:bonfire/bonfire.dart';
import 'package:world/game/maps/map_arguments.dart';

class ExitMapSensor extends GameDecoration with Sensor<Player> {
  ExitMapSensor(Vector2 position, Vector2 size, this._args) : super(position: position, size: size);

  bool _contacted = false;
  final MapArguments _args;

  @override
  void onContact(Player component) {
    if (_contacted) return;
    _contacted = true;

    MapNavigator.of(context).toNamed(_args.destMap.name, arguments: _args.withSourcePosition(component.position));
  }
}
