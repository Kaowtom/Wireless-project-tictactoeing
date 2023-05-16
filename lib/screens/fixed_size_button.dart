import 'package:flutter/material.dart';

class FixedSizeButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback onPressed;

  FixedSizeButton({
    required this.child,
    required this.onPressed,
    this.width = 200.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
