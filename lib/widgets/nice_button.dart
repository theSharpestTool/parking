import 'package:flutter/material.dart';

class NiceButton extends StatelessWidget {
  final String _text;
  final Function _function;

  NiceButton(this._text, this._function);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledTextColor: Color(0xFFcccaca),
      color: Colors.transparent,
      elevation: 0.0,
      onPressed: _function,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF4D8AF0),
              Color(0xFF689AEE),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(77, 138, 240, 0.25),
              offset: Offset(0.0, 12.0),
              blurRadius: 12.0,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(
          _text,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
