import 'package:flutter/material.dart';
import 'package:lovely/ui/widgets/photo.dart';

Widget profileWidget(
    {padding,
    photoHeight,
    photoWidth,
    clipRadius,
    photo,
    containerHeight,
    containerWidth,
    child}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(clipRadius),
      ),
      elevation: 20,
      shadowColor: Colors.pink[100]!,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: photoWidth,
            height: photoHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(clipRadius),
              child: PhotoWidget(
                photoLink: photo,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.pink[50]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                color: Colors.pink[50],
                borderRadius: BorderRadius.all(Radius.circular(clipRadius))),
            width: containerWidth,
            height: containerHeight,
            child: child,
          )
        ],
      ),
    ),
  );
}
