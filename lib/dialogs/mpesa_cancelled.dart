
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';

class MpesaCancelledDialog extends StatefulWidget {
  const MpesaCancelledDialog({Key? key}) : super(key: key);

  @override
  _MpesaCancelledDialogState createState() => _MpesaCancelledDialogState();
}

class _MpesaCancelledDialogState extends State<MpesaCancelledDialog> {
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
          "Request cancelled by \nuser",
          style: appstyle(18, AppColors.black, FontWeight.w400),
        ),
      ),
    );
  }
}
