import 'package:flutter/material.dart';

class AppIconsButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final Color iconColor;

  const AppIconsButton({
    Key? key,
    required this.onTap,
    required this.iconData,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        iconData,
        color: iconColor,
        size: 25,
      ),
    );
  }
}
