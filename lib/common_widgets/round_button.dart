import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final String buttonText;
  final VoidCallback onPressed;

  const RoundButton({
    Key? key,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: appstyle(17, AppColors.white, FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
