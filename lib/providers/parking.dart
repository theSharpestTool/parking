import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:park_it/providers/user_location_provider.dart';

class Parking with ChangeNotifier {
  double _latitude;
  double _longitude;
  String _title;
  int _price;
  String _phoneNumber;
  String _schedule;
  String _image;
  String _id = DateTime.now().toString();
  final Distance _distance = Distance();

  Parking({
    @required double latitude,
    @required double longitude,
    String title,
    int price,
    String phoneNumber,
    String schedule,
    String image,
  }) {
    this._latitude = latitude;
    this._longitude = longitude;
    this._title ??= title;
    this._price ??= price;
    this._phoneNumber ??= phoneNumber;
    this._schedule ??= schedule;
    this._image ??= image;
  }

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get title => _title;
  int get price => _price;
  String get phoneNumber => _phoneNumber;
  String get schedule => _schedule;
  String get address => 'ул Академика Барабашова 132 Г';
  String get image => _image;
  String get id => _id;
  int get distance {
    if (!UserLocationProvider().isLoaded) return 0;
    final dist = _distance(
      LatLng(UserLocationProvider().latitude, UserLocationProvider().longitude),
      LatLng(_latitude, _longitude),
    ).round();
    return dist;
  }
}
