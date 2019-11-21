import 'package:flutter/material.dart';
import 'package:park_it/providers/parking.dart';
import 'package:provider/provider.dart';

class ParkingInfoBox extends StatelessWidget {
  final BoxConstraints _constraints;

  ParkingInfoBox(this._constraints);
  @override
  Widget build(BuildContext context) {
    final parking = Provider.of<Parking>(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      child: Container(
        padding: EdgeInsets.only(top: _constraints.maxHeight / 30.0),
        color: Colors.white,
        child: parking == null
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildDistanceBox(_constraints),
                      _buildParkingTitle(_constraints, context),
                    ],
                  ),
                  SizedBox(
                    height: _constraints.maxHeight / 50.0,
                  ),
                  _buildShedulePriceRow(_constraints, context),
                  SizedBox(
                    height: _constraints.maxHeight / 50.0,
                  ),
                  _buildPhoneRow(_constraints, context),
                ],
              ),
      ),
    );
  }

  Container _buildPhoneRow(BoxConstraints constraints, BuildContext context) {
    final parking = Provider.of<Parking>(context);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: constraints.maxWidth / 4.8,
          ),
          Image.asset(
            'assets/phone.png',
            width: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              parking?.phoneNumber ?? '',
              style: TextStyle(fontSize: constraints.maxWidth / 20.0),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildShedulePriceRow(BoxConstraints constraints, BuildContext context) {
    final parking = Provider.of<Parking>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: constraints.maxWidth / 14.0,
        ),
        Row(
          children: <Widget>[
            Container(
              color: Color(0xFF689AEE),
              width: 3.0,
              height: constraints.maxHeight / 40.0,
              margin: EdgeInsets.only(right: 6.0),
            ),
            Text(
              parking?.schedule ?? '',
              style: TextStyle(
                fontSize: constraints.maxWidth / 25.0,
              ),
            ),
          ],
        ),
        Text(
          parking != null ? '${parking.price} грн/час' : '',
          style: TextStyle(
            fontSize: constraints.maxWidth / 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(),
      ],
    );
  }

  Container _buildDistanceBox(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color(0xFF614DF0),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Text(
        '503 м',
        style: TextStyle(
          color: Color(0xFF614DF0),
          fontSize: constraints.maxWidth / 28.0,
        ),
      ),
    );
  }

  Column _buildParkingTitle(BoxConstraints constraints, BuildContext context) {
    final parking = Provider.of<Parking>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          parking?.title ?? '',
          style: TextStyle(
            fontSize: constraints.maxWidth / 21,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          parking?.address ?? '',
          style: TextStyle(
            fontSize: constraints.maxWidth / 25,
            color: Color(0xFF666666),
          ),
        )
      ],
    );
  }
}
