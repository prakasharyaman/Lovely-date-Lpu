import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class PhotoWidget extends StatelessWidget {
  final String photoLink;

  const PhotoWidget({required this.photoLink});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      photoLink,
      fit: BoxFit.cover,
      cache: true,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: CircularProgressIndicator(),
            );

          case LoadState.completed:
            return null;

          case LoadState.failed:
            return GestureDetector(
              child: Center(
                child: Text("Reload"),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
        }
      },
    );
  }
}
