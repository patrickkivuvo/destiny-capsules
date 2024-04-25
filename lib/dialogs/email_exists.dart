import 'package:destiny_capsules/constants/app_defaults.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';

class EmailExistDialog extends StatelessWidget {
  const EmailExistDialog({Key? key}) : super(key: key);

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
                    "An Error occured",
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
                  'Email or Phone has already been taken',
                  style: appstyle(14, AppColors.secondaryText, FontWeight.w400),
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
