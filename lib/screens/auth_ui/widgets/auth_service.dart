import 'dart:convert';
import 'package:destiny_capsules/constants/utils.dart';
import 'package:destiny_capsules/dialogs/email_exists.dart';
import 'package:destiny_capsules/dialogs/register_successful.dart';
import 'package:destiny_capsules/dialogs/verified.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/screens/auth_ui/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';

class AuthService {
  // register a user
  static Future<void> signUpUser({
    required BuildContext context,
    required String? email,
    required String? password,
    required String? firstname,
    required String? lastname,
    required String? mobile,
    required String? confirmpassword,
  }) async {
    try {
      if (email == null ||
          password == null ||
          firstname == null ||
          lastname == null ||
          mobile == null ||
          confirmpassword == null) {
        print('One or more required parameters are null');
        return;
      }

      Map<String, dynamic> requestBody = {
        'first_name': firstname,
        'last_name': lastname,
        'phone_number': mobile,
        'email': email,
        'password': password,
        'password_confirmation': confirmpassword,
      };
      showLoaderDialog(context);
      http.Response res = await http.post(
        Uri.parse('$baseUrl/users/register/'),
        body: json.encode(requestBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Navigator.pop(context);
      if (res.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(res.body);
        int id = responseData['id'];
        print('User created with ID: $id');
        showGeneralDialog(
          barrierLabel: 'Dialog',
          barrierDismissible: true,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => const RegisterSuccessfulDialog(),
          transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      } else if (res.statusCode == 400) {
        print('Email or phone already exists');
        showGeneralDialog(
          barrierLabel: 'Dialog',
          barrierDismissible: true,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => const EmailExistDialog(),
          transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        showSnackBar(
          context,
          'Failed to create account. Please try again.',
        );
      }
    } catch (e) {
      print('Error: $e');
      showSnackBar(
        context,
        'An error occurred. Please try again later.',
      );
    }
  }

  // login user
 static Future<void> logInUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    showLoaderDialog(context);
    http.Response res = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Navigator.pop(context);
    print('Response Body: ${res.body}');
    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Clear previous user data
      await prefs.clear();
      // Save token to SharedPreferences
      await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
      showGeneralDialog(
        barrierLabel: 'Dialog',
        barrierDismissible: true,
        context: context,
        pageBuilder: (ctx, anim1, anim2) => const VerifiedDialog(),
        transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
          scale: anim1,
          child: child,
        ),
      );
      // Notify listeners or navigate to HomeScreen here
    } else {
      // Handle login failure
    }
  } catch (e) {
    print(e.toString());
  }
}


  // logout user
  static Future<bool> logOutUser({
    required BuildContext context,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/logout/'),
      );
      if (response.statusCode == 200) {
        Provider.of<AppProvider>(context, listen: false)
            .logout(); // Logout locally
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LogInScreen(),
          ),
        );
        // Successful logout
        return true;
      } else {
        // Logout failed
        print("Failed to logout. Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Error occurred during logout
      print("Error during logout: $e");
      return false;
    }
  }
}
