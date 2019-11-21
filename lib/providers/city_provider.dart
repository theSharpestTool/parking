import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';

const String API_KEY = 'AIzaSyD2ozdfoh_OjOctxdJr9rrJpKxsoQjdiL8';

class CityProvider with ChangeNotifier {
  String _cityName = "Харьков"; //is null
  double _cityLat = 49.994201081; //is null
  double _cityLng = 36.254383369; //is null
  List<String> _cityPredictions = [];

  final _googleMapsPlaces = GoogleMapsPlaces(apiKey: API_KEY);

  String get city => _cityName;
  double get cityLat => _cityLat;
  double get cityLng => _cityLng;
  List<String> get cityPredictions => _cityPredictions;

  void getCityPredictions(String input) async {
    final response = await _googleMapsPlaces.autocomplete(
      input,
      types: ['(cities)'],
      components: [Component('country', 'ua')],
    );
    final citiesInfo = response.predictions;
    _cityPredictions = citiesInfo.map((prediction) {
      final cityName = prediction.description.split(',').first;
      return cityName;
    }).toList();
    notifyListeners();
  }
}
