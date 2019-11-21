import 'package:flutter/material.dart';
import 'package:park_it/providers/parking.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final parking = Provider.of<Parking>(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (parking?.image != null)
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: parking.image,
                fadeInDuration: Duration(milliseconds: 400),
              ),
          ],
        ),
      ),
    );
  }
}
