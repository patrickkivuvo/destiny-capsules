import 'dart:convert';

import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/common_widgets/round_button.dart';
import 'package:destiny_capsules/common_widgets/round_textfield.dart';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/screens/auth_ui/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController resetEmail = TextEditingController();
  bool isRequesting = false;

  resetPasswordRequest() async {
    showLoaderDialog(context);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/forgot/'),
    );
    request.fields.addAll({'email': resetEmail.text});

    http.StreamedResponse response = await request.send();
    Navigator.pop(context);
    if (response.statusCode == 200) {
      setState(() {
        isRequesting = false;
      });
      print(await response.stream.bytesToString());
      showMessage("Check your email for a reset email");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LogInScreen(),
        ),
      );
    } else {
      print(response.reasonPhrase);
      var data = jsonDecode(await response.stream.bytesToString());
      print(data);
      setState(() {
        isRequesting = false;
      });
    }
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 6,
            ),
            Text(
              "Forgot Password",
              style: appstyle(20, AppColors.black, FontWeight.w700),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Please enter your email and we will send you a link to reset your password",
              style: appstyle(14, AppColors.black, FontWeight.w400),
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Enter Your Email",
              controller: resetEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 25,
            ),
            RoundButton(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.black,
              buttonText: 'Continue',
              onPressed: () {
                resetPasswordRequest();
              },
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
