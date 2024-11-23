import 'package:flutter/material.dart';
import 'package:minesweeper/helpers/app_font.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width = double.infinity,
    this.height = 60,
    this.isEnabled = true,
    this.elevation = 10,
    this.backgroundColor = Colors.grey,
  });
  final void Function()? onPressed;
  final String title;
  final double width;
  final double height;
  final bool isEnabled;
  final double elevation;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey[800],
        shadowColor: Colors.grey,
        maximumSize: const Size(
          300,
          80,
        ),
        fixedSize: Size(width, height),
        elevation: elevation,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontFamily: AppFonts.minesweeper,
        ),
      ),
    );
  }
}
