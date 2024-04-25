import 'package:destiny_capsules/constants/app_defaults.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/screens/auth_ui/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterSuccessfulDialog extends StatelessWidget {
  const RegisterSuccessfulDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Account created Successfully",
                    style: appstyle(16, AppColors.black, FontWeight.w600),
                  ),
                )),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Check your email for a verification email',
                  style: appstyle(14, AppColors.secondaryText, FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogInScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Login',
                    style: appstyle(17, AppColors.primary, FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
