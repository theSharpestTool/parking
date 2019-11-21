import 'package:flutter/material.dart';

class NiceDecoration {
  static BoxDecoration get instace {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          offset: Offset(0.0, 2.0),
          blurRadius: 6.0,
          color: Color.fromRGBO(165, 159, 247, 0.25),
        ),
      ],
      border: Border.all(
        color: Color(0xFFCBD6FA),
        width: 0.5,
      ),
    );
  }
}
