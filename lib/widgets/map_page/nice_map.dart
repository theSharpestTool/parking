import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_it/managers/marker_manager.dart';
import 'package:park_it/providers/city_provider.dart';
import 'package:park_it/providers/parkings_provider.dart';
import 'package:park_it/providers/user_location_provider.dart';
import 'package:provider/provider.dart';

class NiceMap extends StatefulWidget {
  NiceMap({Key key}) : super(key: key);
  @override
  NiceMapState createState() => NiceMapState();
}

class NiceMapState extends State<NiceMap> {
  GoogleMapController _mapController;
  double _zoom = 11.0;

  @override
  Widget build(BuildContext context) {
    print('build');
    final cityProvider = Provider.of<CityProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final parkingsProvider = Provider.of<ParkingsProvider>(context);
      if (!parkingsProvider.mapAnimation) return;
      if (parkingsProvider.selectedParking == null)
        _unselectParking();
      else
        _selectParking();
    });
    return GoogleMap(
      rotateGesturesEnabled: false,
      onMapCreated: (GoogleMapController controller) =>
          _mapController = controller,
      compassEnabled: true,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      markers: _getMarkers(),
      onCameraMove: _onGeoChanged,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          cityProvider.cityLat,
          cityProvider.cityLng,
        ),
        zoom: _zoom,
      ),
    );
  }

  Set<Marker> _getMarkers() {
    final mapProvider = Provider.of<ParkingsProvider>(context);
    final markers = mapProvider.parkings.map(
      (parking) {
        final position = LatLng(parking.latitude, parking.longitude);
        final markerIcon = mapProvider.selectedParking?.id == parking.id
            ? MarkerManager().selectedMarkerIcon
            : MarkerManager().markerIcon;
        return Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () =>
              Provider.of<ParkingsProvider>(context).selectParking(parking),
        );
      },
    ).toSet();

    final userProvider = Provider.of<UserLocationProvider>(context);
    if (userProvider.isLoaded) {
      final userPosition =
          LatLng(userProvider.latitude, userProvider.longitude);
      markers.add(
        Marker(
          consumeTapEvents: true,
          zIndex: 0.1,
          anchor: Offset(0.5, 0.5),
          rotation: userProvider.rotation,
          markerId: MarkerId(userPosition.toString()),
          position: userPosition,
          icon: BitmapDescriptor.fromBytes(MarkerManager().carIcon),
        ),
      );
    }
    return markers;
  }

  void _onGeoChanged(CameraPosition position) {
    _zoom = position.zoom;
  }

  Future<void> _selectParking() async {
    final parking = Provider.of<ParkingsProvider>(context).selectedParking;
    final offset = MediaQuery.of(context).size.height / 181796.0;
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            parking.latitude - offset,
            parking.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<void> _unselectParking() async {
    final cityProvider = Provider.of<CityProvider>(context);
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(cityProvider.cityLat, cityProvider.cityLng),
          zoom: 11.0,
        ),
      ),
    );
  }
}
