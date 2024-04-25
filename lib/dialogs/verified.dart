import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/screens/home/home_screen.dart';
import 'package:destiny_capsules/common_widgets/round_button.dart';
import 'package:flutter/material.dart';

class VerifiedDialog extends StatelessWidget {
  const VerifiedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15 * 3,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'LoggedIn!',
              style: appstyle(18, AppColors.black, FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Text(
              "Congratulations! You have successfully\nlogged into your account.",
              style: appstyle(16, AppColors.secondaryText, FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            RoundButton(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.black,
              buttonText: 'Browse Home',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
