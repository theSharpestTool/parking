import 'package:flutter/widgets.dart';
import 'package:park_it/providers/parking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:park_it/providers/user_location_provider.dart';

class ParkingsProvider with ChangeNotifier {
  List<Parking> _parkings = [];
  Parking _selectedParking;
  Parking _lastSelectedParking;
  bool _parkingsLoaded = false;
  bool _mapAnimation = false;

  final location = Location();

  List<Parking> get parkings {
    final List<Parking> parkings = List.from(_parkings);
    parkings.sort((parking1, parking2) {
      return parking1.distance.compareTo(parking2.distance);
    });
    return parkings;
  }

  Parking get selectedParking => _selectedParking;
  Parking get lastSelectedParking => _lastSelectedParking;
  bool get parkingsLoaded => _parkingsLoaded;
  bool get mapAnimation => _mapAnimation;

  Future<void> loadParkings() async {
    final querySnapshot =
        await Firestore.instance.collection('parkings').getDocuments();
    final documents = querySnapshot.documents;

    _parkings = documents.map((document) {
      final parkingData = document.data;
      final GeoPoint location = parkingData['location'];
      return Parking(
        latitude: location.latitude,
        longitude: location.longitude,
        title: parkingData['title'],
        price: parkingData['price'],
        phoneNumber: parkingData['phoneNumber'],
        schedule: parkingData['schedule'],
        image: parkingData['image'],
      );
    }).toList();

    _parkingsLoaded = true;
    notifyListeners();
  }

  void selectParking(Parking parking) async {
    _lastSelectedParking = _selectedParking;
    _selectedParking = parking;
    UserLocationProvider().pauseListening();
    _mapAnimation = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    UserLocationProvider().resumeListening();
    _mapAnimation = false;
  }
}
