import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park_it/pages/my_car_page.dart';
import 'package:park_it/pages/my_card_page.dart';
import 'package:park_it/providers/ui_provider.dart';
import 'package:provider/provider.dart';

class OptionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 50.0,
        bottom: 30.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildOptionButton('Моя машина', 'assets/car.svg', context),
          _buildOptionButton('Моя карта', 'assets/credit_card.svg', context),
          _buildOptionButton('История', 'assets/clock.svg', context),
          _buildOptionButton('Выйти', 'assets/login.svg', context),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
      String text, String iconAsset, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) {
              if (text == 'Моя карта') return MyCardPage();
              else return MyCarPage();
            },
          ),
        );
        final uiProvider = Provider.of<UIProvider>(context);
        uiProvider.showOptions();
      },
      child: Container(
        width: 240.0,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 30.0),
            SvgPicture.asset(iconAsset),
            SizedBox(width: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
