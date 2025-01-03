import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double width;
  final double height;
  final ImageProvider imageProvider;
  const ProfileImage(
      {super.key,
      required this.width,
      required this.height,
      required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999), // Rounded corners
        border: Border.all(
          color: Colors.grey, // Border color
          width: 2, // Border width
        ),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover, // Adjust image to fit the container
        ),
      ),
    );
  }
}
