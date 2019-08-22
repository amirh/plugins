import 'dart:async';

/// Indicates the current battery state.
enum BatteryState { full, charging, discharging }

class BatteryPlatform {

  /// Returns the current battery level in percent.
  Future<int> getBatteryLevel() {
    throw UnimplementedError(
        "Battery getBatteryLevel is not implemented on the current platform");
  }

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    throw UnimplementedError(
        "Battery onBatteryStateChanged is not implemented on the current platform");
  }
}
