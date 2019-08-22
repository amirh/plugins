// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:battery/src/method_channel_battery.dart';
import 'package:flutter/foundation.dart';

import 'battery_platform_interface.dart';

class Battery {
  
  factory Battery() {
    if (_instance == null) {
      _instance = Battery._();
    }
    return _instance;
  }

  Battery._();


  static Battery _instance;

  static BatteryPlatform _platform;

  /// Sets a custom [BatteryPlatform].
  ///
  /// This property can be set to use a custom platform implementation.
  static set platform(BatteryPlatform platform) {
    assert(_platform == null);
    _platform = platform;
  }

  /// The Battery platform that's used by the plugin.
  ///
  /// The default value is [MethodChannelBattry] on Android on iOS.
  static BatteryPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = MethodChannelBattery();
          break;
        case TargetPlatform.iOS:
          _platform = MethodChannelBattery();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default battery implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform;
  }

  /// Returns the current battery level in percent.
  Future<int> get batteryLevel => platform.getBatteryLevel();

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged  => platform.onBatteryStateChanged;
}
