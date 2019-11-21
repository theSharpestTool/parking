import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:park_it/pages/registration_page.dart';
import 'package:park_it/pages/search_page.dart';
import 'package:park_it/providers/parkings_provider.dart';
import 'package:park_it/providers/ui_provider.dart';
import 'package:park_it/providers/profile_provider.dart';
import 'package:park_it/providers/user_location_provider.dart';
import 'package:park_it/widgets/map_page/image_box.dart';
import 'package:park_it/widgets/map_page/nice_map.dart';
import 'package:park_it/widgets/nice_background.dart';
import 'package:park_it/widgets/nice_button.dart';
import 'package:park_it/widgets/map_page/options_list.dart';
import 'package:park_it/pages/park_here_page.dart';
import 'package:park_it/widgets/map_page/parking_info_box.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BoxConstraints _pageConstraints;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goBack();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            NiceBackground(),
            _buildPageContent(),
          ],
        ),
      ),
    );
  }

  Scaffold _buildPageContent() {
    final parkingProvider = Provider.of<ParkingsProvider>(context);
    final show = Provider.of<UIProvider>(context).searchPageShown;
    final placeSelected = parkingProvider.selectedParking != null;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: show || placeSelected ? null : _buildSearchButton(),
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 3.0),
        child: _buildPageStack(),
      ),
    );
  }

  FloatingActionButton _buildSearchButton() {
    final uiProvider = Provider.of<UIProvider>(context);
    return FloatingActionButton(
      elevation: 2,
      onPressed: () => uiProvider.showSearchPage(true),
      child: Icon(
        Icons.search,
        color: Color(0xFF4D8AF0),
      ),
      backgroundColor: Colors.white,
    );
  }

  AppBar _buildAppBar() {
    final placeSelected =
        Provider.of<ParkingsProvider>(context).selectedParking != null;
    final showSearchPage = Provider.of<UIProvider>(context).searchPageShown;
    final showOptionsPage = Provider.of<UIProvider>(context).optionsShown;
    return AppBar(
      leading: IconButton(
        icon: !showSearchPage && !placeSelected && !showOptionsPage
            ? SvgPicture.asset(
                'assets/menu_icon.svg',
                color: Color(0xFF4D8AF0),
              )
            : Icon(
                Icons.arrow_back,
                color: Color(0xFF4D8AF0),
              ),
        onPressed: _goBack,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showSearchPage
              ? Icon(
                  Icons.search,
                  color: Color(0xFF4D8AF0),
                )
              : SvgPicture.asset('assets/logo.svg'),
          SizedBox(width: 9.0),
          Text(
            showSearchPage ? "Поиск" : "Park-it",
            style: TextStyle(
              color: Colors.black,
              fontWeight: showSearchPage ? FontWeight.w500 : FontWeight.w600,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
      centerTitle: true,
      bottomOpacity: 0.0,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget _buildPageStack() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parkingProvider = Provider.of<ParkingsProvider>(context);
        final placeSelected = parkingProvider.selectedParking != null;

        final uiProvider = Provider.of<UIProvider>(context);
        final showSearchPage = uiProvider.searchPageShown;
        final showOptionsPage = uiProvider.optionsShown;
        final paymentStarted = uiProvider.paymentStarted;

        _pageConstraints ??= constraints;
        return Stack(
          children: <Widget>[
            Positioned(
              top: 2.0,
              child: ChangeNotifierProvider.value(
                value: parkingProvider.selectedParking ??
                    parkingProvider.lastSelectedParking,
                child: ImageBox(),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: placeSelected &&
                      !paymentStarted &&
                      parkingProvider.selectedParking?.image != null
                  ? _pageConstraints.maxHeight / 5.0
                  : 2.0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ChangeNotifierProvider.value(
                value: parkingProvider.selectedParking ??
                    parkingProvider.lastSelectedParking,
                child: ParkingInfoBox(_pageConstraints),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: placeSelected
                  ? parkingProvider.selectedParking?.image != null
                      ? _pageConstraints.maxHeight / 2.0
                      : _pageConstraints.maxHeight / 3.8
                  : 0.0,
              width: _pageConstraints.maxWidth,
              height: _pageConstraints.maxHeight,
              child: _buildMap(),
            ),
            Align(
              alignment: parkingProvider.selectedParking?.image != null ||
                      parkingProvider.selectedParking == null
                  ? Alignment.center
                  : Alignment(0.0, -0.5),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: placeSelected ? 186.0 : 0.0,
                height: 43.0,
                child: NiceButton("Парковаться тут!", () => _park(true)),
              ),
            ),
            AnimatedPositioned(
              top: showSearchPage ? 0.0 : _pageConstraints.maxHeight,
              duration: Duration(milliseconds: 300),
              width: _pageConstraints.maxWidth,
              height: _pageConstraints.maxHeight,
              child: SearchPage(),
            ),
            Positioned(
              width: showOptionsPage ? _pageConstraints.maxWidth : 0.0,
              height: showOptionsPage ? _pageConstraints.maxHeight : 0.0,
              child: InkWell(onTap: () => uiProvider.optionsShown),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: !showOptionsPage ? -240.0 : 0.0,
              child: OptionsList(),
            ),
            AnimatedPositioned(
              top: paymentStarted
                  ? _pageConstraints.maxHeight / 5.5
                  : _pageConstraints.maxHeight,
              duration: Duration(milliseconds: 300),
              width: _pageConstraints.maxWidth,
              height: _pageConstraints.maxHeight / 1.22,
              child: ParkHereBox(_pageConstraints.maxHeight / 1.22),
            ),
          ],
        );
      },
    );
  }

  void _goBack() {
    final parkingProvider = Provider.of<ParkingsProvider>(context);
    final placeSelected =
        Provider.of<ParkingsProvider>(context).selectedParking != null;

    final uiProvider = Provider.of<UIProvider>(context);
    final showSearchPage = Provider.of<UIProvider>(context).searchPageShown;
    final paymentStarted = Provider.of<UIProvider>(context).paymentStarted;

    if (MediaQuery.of(context).viewInsets.bottom > 0.0)
      FocusScope.of(context).unfocus();
    else if (showSearchPage)
      uiProvider.showSearchPage(false);
    else if (placeSelected) {
      if (paymentStarted)
        _park(false);
      else
        parkingProvider.selectParking(null);
    } else
      uiProvider.showOptions();
  }

  void _park(bool startPayment) async {
    if (ProfileProvider().phoneNumber == null)
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: ProfileProvider(),
            child: RegistrationPage(),
          ),
        ),
      );
    final uiProvider = Provider.of<UIProvider>(context);
    uiProvider.startPayment(startPayment);
  }

  Container _buildMap() {
    final userLocationProvider = Provider.of<UserLocationProvider>(context);
    final parkingsProvider = Provider.of<ParkingsProvider>(context);
    if (!userLocationProvider.isLoaded) userLocationProvider.loadLocation();
    if (!parkingsProvider.parkingsLoaded) parkingsProvider.loadParkings();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        border: Border.all(
          color: Color.fromRGBO(167, 160, 247, 0.25),
          width: 1.6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: NiceMap(),
      ),
    );
  }
}
