import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int followerCount;
  final int followingCount;
  final double spacing;
  final String userName;
  final String email;
  const ProfileStats(
      {super.key,
      required this.followerCount,
      required this.followingCount,
      required this.userName,
      required this.email,
      required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          email,
          style: const TextStyle(
            fontSize: 15, // Font size
            fontWeight: FontWeight.w600, // Bold font weight
            fontStyle: FontStyle.italic, // Italic text
            decoration: TextDecoration.underline, // Underline text
          ),
        ),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 15, // Font size
            fontWeight: FontWeight.w600, // Bold font weight
            fontStyle: FontStyle.italic, // Italic text
            decoration: TextDecoration.underline, // Underline text
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: spacing,
          children: [
            Column(children: [
              const Text(
                "followers",
                style: TextStyle(
                  fontSize: 25, // Font size
                  fontWeight: FontWeight.bold, // Bold font weight
                  fontStyle: FontStyle.italic, // Italic text
                  decoration: TextDecoration.underline, // Underline text
                ),
              ),
              Text(
                followerCount.toString(),
              )
            ]),
            Column(children: [
              const Text(
                "following",
                style: TextStyle(
                  fontSize: 25, // Font size
                  fontWeight: FontWeight.bold, // Bold font weight
                  fontStyle: FontStyle.italic, // Italic text
                  decoration: TextDecoration.underline, // Underline text
                ),
              ),
              Text(
                followingCount.toString(),
              )
            ])
          ],
        )
      ],
    );
  }
}
