import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {},
      child: SizedBox(
        width: 27,
        height: 27,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
            ),
          ),
          child: const Center(
            child: Image(
              image: AssetImage('assets/img/menu.png'),
              width: 15,
              height: 15,
            ),
          ),
        ),
      ),
    );
  }
}
