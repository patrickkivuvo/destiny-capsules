import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../dialogs/mpesa_confirm.dart';

class MpesaButton extends StatelessWidget {
  const MpesaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          showGeneralDialog(
            barrierLabel: 'Dialog',
            barrierDismissible: true,
            context: context,
            pageBuilder: (ctx, anim1, anim2) => const MpesaConfirmDialog(),
            transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
              scale: anim1,
              child: child,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
        ),
        child: Text(
          'CHECKOUT',
          style: appstyle(17, AppColors.white, FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
