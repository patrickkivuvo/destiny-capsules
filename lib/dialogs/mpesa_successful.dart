
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';

class MpesaSuccessDialog extends StatefulWidget {
  const MpesaSuccessDialog({Key? key}) : super(key: key);

  @override
  _MpesaSuccessDialogState createState() => _MpesaSuccessDialogState();
}

class _MpesaSuccessDialogState extends State<MpesaSuccessDialog> {
  bool isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15 * 2,
          horizontal: 15,
        ),
        child: Text(
          "Your Order was placed \nSuccessfully",
          style: appstyle(18, AppColors.black, FontWeight.w400),
        ),
      ),
    );
  }
}
