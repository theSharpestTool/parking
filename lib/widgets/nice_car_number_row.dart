import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'nice_decoration.dart';

class NiceCarNumberRow extends StatelessWidget{
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230.0,
      height: 50.0,
      margin: EdgeInsets.all(12.0),
      decoration: NiceDecoration.instace,
      child: Row(
        children: <Widget>[
          _buildUkraineFlag(),
          Spacer(
            flex: 7,
          ),
          _buildCarNumberField(),
          Spacer(
            flex: 8,
          ),
        ],
      ),
    );
  }

  Flexible _buildCarNumberField() {
    _textController.text = 'АХ 1301 ВИ';
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);

    return Flexible(
      flex: 32,
      child: TextField(
        controller: _textController,
        style: TextStyle(
          fontSize: 21.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Container _buildUkraineFlag() {
    return Container(
      width: 41.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0xFF4F8BF0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/ukraine.svg',
            height: 20.0,
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            'UA',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}