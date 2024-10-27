import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:world/game/menu/menu_overlay.dart';

class ShowMenuSensor extends GameDecoration with Sensor<Player> {
  ShowMenuSensor(Vector2 position, Vector2 size, this._menuKey, this._contacted)
      : super(position: position, size: size);

  bool _contacted;
  final GlobalKey<MenuOverlayState> _menuKey;

  @override
  void onContact(Player component) {
    if (_contacted) return;
    _contacted = true;
    _menuKey.currentState?.mode = MenuMode.collapsed;
  }

  @override
  void onContactExit(Player component) {
    if (!_contacted) return;
    _contacted = false;
    _menuKey.currentState?.mode = MenuMode.homeOnly;
  }
}
