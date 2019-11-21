import 'package:flutter/material.dart';
import 'package:park_it/managers/marker_manager.dart';
import 'package:park_it/pages/map_page.dart';
import 'package:park_it/providers/city_provider.dart';
import 'package:park_it/providers/parkings_provider.dart';
import 'package:park_it/providers/ui_provider.dart';
import 'package:park_it/providers/profile_provider.dart';
import 'package:park_it/providers/user_location_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<bool> _init() async {
    await ProfileProvider().init();
    await MarkerManager().init();
    /*FlutterCompass.events.listen((double direction) {
      print(direction);
    });*/
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('ru', 'UA'),
      title: 'Park It',
      theme: ThemeData(
        fontFamily: 'Avenir Next',
      ),
      home: FutureBuilder<bool>(
          future: _init(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: ParkingsProvider()),
                  ChangeNotifierProvider.value(value: UIProvider()),
                  ChangeNotifierProvider.value(value: CityProvider()),
                  ChangeNotifierProvider.value(value: UserLocationProvider()),
                ],
                child: MapPage(),
              );
            else
              return Scaffold();
          }),
    );
  }
}
