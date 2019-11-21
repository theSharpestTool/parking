import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';

class UserLocationProvider with ChangeNotifier {
  static final UserLocationProvider _instance =
      UserLocationProvider._internal();
  factory UserLocationProvider() => _instance;
  UserLocationProvider._internal();

  double _latitude;
  double _longitude;
  double _rotation;
  bool _isLoaded = false;
  bool _pause = false;

  final _location = Location();
  StreamSubscription<LocationData> _locationListener;
  StreamSubscription<double> _compassListener;

  double get latitude => _latitude;
  double get longitude => _longitude;
  double get rotation => _rotation;
  bool get isLoaded => _isLoaded && _latitude != null;

  void pauseListening() {
    _pause = true;
    print('PAUSE $_pause');
  }

  void resumeListening() {
    _pause = false;
    print('RESUME');
  }

  void loadLocation() async {
    _locationListener = _location.onLocationChanged().listen((value) {
      print('loc changed');
      _latitude = value.latitude;
      _longitude = value.longitude;
      if (!_pause) notifyListeners();
    });

    _compassListener = FlutterCompass.events.listen((double direction) async {
      print('dir changed $direction $_pause');
      _rotation = direction - 25.0;
      if (!_pause) notifyListeners();
    });
    _isLoaded = true;
  }
}
