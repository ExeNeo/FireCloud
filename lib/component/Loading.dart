import "package:cloud/utils/Colors.dart";
import "package:flutter/material.dart";


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: CSecondColor,
        backgroundColor: CSPrimaryColor,
      ),
    );
  }
}