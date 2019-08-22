import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;

import '../battery_platform_interface.dart';

class MethodChannelBattery extends BatteryPlatform {
  MethodChannelBattery() {
      _methodChannel = const MethodChannel('plugins.flutter.io/battery');
      _eventChannel = const EventChannel('plugins.flutter.io/charging');
  }

  @visibleForTesting
  MethodChannelBattery.private(this._methodChannel, this._eventChannel);

  MethodChannel _methodChannel;
  EventChannel _eventChannel;

  Stream<BatteryState> _onBatteryStateChanged;

  @override
  Future<int> getBatteryLevel() {
    return _methodChannel
        .invokeMethod<int>('getBatteryLevel')
        .then<int>((dynamic result) => result);
  }

  @override
  Stream<BatteryState> get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseBatteryState(event));
    }
    return _onBatteryStateChanged;
  }
}

BatteryState _parseBatteryState(String state) {
  switch (state) {
    case 'full':
      return BatteryState.full;
    case 'charging':
      return BatteryState.charging;
    case 'discharging':
      return BatteryState.discharging;
    default:
      throw ArgumentError('$state is not a valid BatteryState.');
  }
}
