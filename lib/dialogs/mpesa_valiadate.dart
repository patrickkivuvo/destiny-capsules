import 'dart:convert';

import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/dialogs/mpesa_cancelled.dart';
import 'package:destiny_capsules/dialogs/mpesa_successful.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MpesaValidateDialog extends StatefulWidget {
  const MpesaValidateDialog({Key? key}) : super(key: key);

  @override
  _MpesaValidateDialogState createState() => _MpesaValidateDialogState();
}

class _MpesaValidateDialogState extends State<MpesaValidateDialog> {
  bool isRequesting = false;
    String _transactionId = '';
     final String _phoneNumber = '';
  final String _amount = '';

  Future<void> _validatePayment(BuildContext context) async {
    //  base URL
    const baseUrl = 'https://destinycapsules.co.ke/api/mpesa/stk-push/validate';
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('x-auth-token');

  if (authToken == null) {
    throw Exception('Token not found. User may not be logged in.');
  }
    
    final response = await http.post(
      Uri.parse(baseUrl),
       body: json.encode({
        'phoneNumber': _phoneNumber,
        'amount': _amount,
      }),
      headers: {
          'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
       
      },
    );

    if (response.statusCode == 200) {
      // Handle successful payment validation
       Navigator.of(context).pop();
        // Then show the MpesaSuccessDialog
        showGeneralDialog(
          barrierLabel: 'Dialog',
          barrierDismissible: true,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => const MpesaSuccessDialog(),
          transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      final responseData = json.decode(response.body);
      setState(() {
        _transactionId = responseData['transactionId'];
      });
    } else {
      // Handle errors
      Navigator.of(context).pop();
        // Then show the MpesaValidateDialog
        showGeneralDialog(
          barrierLabel: 'Dialog',
          barrierDismissible: true,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => const MpesaCancelledDialog(),
          transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      print('Failed to validate payment: ${response.body}');
      // Show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
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
              "Validate Payment",
              style: appstyle(24, AppColors.black, FontWeight.w400),
            ),
            const SizedBox(
              height: 14,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                      _validatePayment(context);
                    showGeneralDialog(
                    barrierLabel: 'Dialog',
                    barrierDismissible: true,
                    context: context,
                    pageBuilder: (ctx, anim1, anim2) =>
                        const MpesaCancelledDialog(),
                    transitionBuilder: (ctx, anim1, anim2, child) =>
                        ScaleTransition(
                      scale: anim1,
                      child: child,
                    ),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Validate",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
