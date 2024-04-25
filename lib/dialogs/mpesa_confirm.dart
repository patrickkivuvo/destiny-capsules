import 'package:destiny_capsules/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';

class MpesaConfirmDialog extends StatefulWidget {
  const MpesaConfirmDialog({Key? key}) : super(key: key);

  @override
  _MpesaConfirmDialogState createState() => _MpesaConfirmDialogState();
}

class _MpesaConfirmDialogState extends State<MpesaConfirmDialog> {
  late User user;
  bool isRequesting = false;

  late List<dynamic> orders = [];
  double totalAmount = 0.0;
  int totalItemCount = 0;

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('x-auth-token');

    if (authToken == null) {
      throw Exception('Token not found. User may not be logged in.');
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/users/orders/'),
      headers: headers,
    );

    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body)['data'];
          calculateTotalAmount(); // Calculate total amount
        });
      } else {
        print('Exception during order placement: ${response.body}');
        throw Exception('Failed to load orders');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    user = Provider.of<AppProvider>(context, listen: false).user;
  }

  void _initiateMpesaPayment(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('x-auth-token');

    if (authToken == null) {
      throw Exception('Token not found. User may not be logged in.');
    }
    setState(() {
      isRequesting = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(
      context,
      listen: false,
    );

    String phoneNumber = user.mobile ?? 'phone number';

    try {
      // Send a POST request to initiate the M-Pesa payment
      final response = await http.post(
        Uri.parse('$baseUrl/users/checkout/'),
        body: json.encode({
          'phone_number': phoneNumber,
          'amount': appProvider.totalPrice().toString(),
        }),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, close the current dialog
        Navigator.of(context).pop();
        // Then show the MpesaValidateDialog
        // showGeneralDialog(
        //   barrierLabel: 'Dialog',
        //   barrierDismissible: true,
        //   context: context,
        //   pageBuilder: (ctx, anim1, anim2) => const MpesaValidateDialog(),
        //   transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
        //     scale: anim1,
        //     child: child,
        //   ),
        // );
      } else {
        // Handle errors
        print('Error initiating M-Pesa payment: ${response.statusCode}');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to initiate M-Pesa payment. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }

    setState(() {
      isRequesting = false;
    });
  }

  void calculateTotalAmount() {
    totalAmount = 0.0;
    for (var order in orders) {
      for (var item in order['items']) {
        final book = item['book'];
        double subtotal = book['price'].toDouble() * item['quantity'];
        totalAmount += subtotal;
      }
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
              "  Mpesa \n  Payment \n  Confirmation \n  for Ksh $totalAmount",
              style: appstyle(24, AppColors.secondaryText1, FontWeight.w400),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              "Click confirm for mpesa prompt then validate after submitting",
              style: appstyle(14, AppColors.secondaryText1, FontWeight.w400),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  _initiateMpesaPayment(context);
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
                child: isRequesting
                    ? const CircularProgressIndicator()
                    : Text(
                        "Confirm",
                        style: appstyle(17, AppColors.white, FontWeight.w400),
                        textAlign: TextAlign.center,
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
