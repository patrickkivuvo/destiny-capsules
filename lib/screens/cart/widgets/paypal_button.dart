import 'dart:convert';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PayPalButton extends StatefulWidget {
  const PayPalButton({Key? key}) : super(key: key);

  @override
  _PayPalButtonState createState() => _PayPalButtonState();
}

class _PayPalButtonState extends State<PayPalButton> {
  late User user;
  bool isRequesting = false;
  late List<dynamic> orders = [];
  double totalAmount = 0.0;
  int totalItemCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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

  Future<void> initiatePayment(BuildContext context) async {
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

    String useremail = user.email ?? 'email';

    final Uri uri = Uri.parse('https://destinycapsules.co.ke/api/paypal/callback');

    try {
      final http.Response response = await http.post(
        uri,
          body: json.encode({
          'email': useremail,
          'amount': appProvider.totalPrice().toString(),
        }),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Payment initiation successful, handle further actions if needed
        // For example, you might need to parse the response and redirect the user to PayPal
        // Handle the response according to your business logic
      } else {
        // Payment initiation failed, handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment initiation failed')),
        );
      }
    } catch (error) {
      // Handle any network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void calculateTotalAmount() {
    totalAmount = 0.0;
    for (var order in orders) {
      for (var item in order['items']) {
        final book = item['book'];
        double subtotal = book['price'].toDouble()/ 113.33 * item['quantity'];
        totalAmount += subtotal;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppProvider>(context, listen: false).user;

    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          initiatePayment(context);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          'Pay with PayPal',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
