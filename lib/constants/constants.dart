import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseUrl = "";

void showMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: const Color(0xff3249CA),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xff3249CA),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(
                  "Loading...",
                  style: appstyle(14, AppColors.primary, FontWeight.w400),
                )),
          ],
        ),
      );
    }),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

bool loginValidation(String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    showMessage("Both Fields are empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is Empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("Password is Empty");
    return false;
  } else {
    return true;
  }
}

bool signUpValidation(String firstname, String lastname, String phone,
    String email, String password, String confirmPassword) {
  if (firstname.isEmpty &&
      lastname.isEmpty &&
      phone.isEmpty &&
      email.isEmpty &&
      password.isEmpty &&
      confirmPassword.isEmpty) {
    showMessage("All Fields are empty");
    return false;
  } else if (firstname.isEmpty) {
    showMessage("FirstName is Empty");
    return false;
  } else if (lastname.isEmpty) {
    showMessage("LastName is Empty");
    return false;
  } else if (phone.isEmpty) {
    showMessage("Phone is Empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is Empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("Password is Empty");
    return false;
  } else if (confirmPassword.isEmpty) {
    showMessage("ConfirmPassword is Empty");
    return false;
  } else if (password != confirmPassword) {
    showMessage("Passwords do not match");
    return false;
  } else {
    return true;
  }
}
