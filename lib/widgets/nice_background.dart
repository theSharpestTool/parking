import 'package:flutter/material.dart';

class NiceBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(165, 159, 247, 0.25),
              offset: const Offset(0.0, 0.0),
            ),
            BoxShadow(
              color: Color(0xFFF7F6FE),
              offset: const Offset(0.0, 2.0),
              blurRadius: 24.0,
              spreadRadius: -10.0,
            ),
          ],
        ),
      ),
    );
  }
}
