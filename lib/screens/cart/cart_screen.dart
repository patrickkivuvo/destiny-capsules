import 'dart:convert';

import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:destiny_capsules/screens/cart/widgets/mpesa_button.dart';
import 'package:destiny_capsules/screens/cart/widgets/paypal_button.dart';
import 'package:destiny_capsules/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/app_provider.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/common_widgets/app_icons_buttons/back_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<dynamic> orders = [];
  late User user;
  double totalAmount = 0.0;
  int totalItemCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserData().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
        });
        Provider.of<AppProvider>(context, listen: false).setUserFromModel(user);
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
      // Handle error, e.g., show a dialog
    });
  }

  // Callback function to handle payment type changes
  void handlePaymentTypeChange(String newPaymentType) {
    setState(() {
      user.setPaymentType(newPaymentType);
    });
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

    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body)['data'];
          calculateTotalAmount(); // Calculate total amount
          calculateTotalItemCount(); // Calculate total item count
        });
      } else {
        print('Exception during order placement: ${response.body}');
        throw Exception('Failed to load orders');
      }
    }
  }

  // Method to delete a book from the cart
  // Method to delete a book from the cart
Future<void> deleteBookFromCart(int bookId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('x-auth-token');

  if (authToken == null) {
    throw Exception('Token not found. User may not be logged in.');
  }

  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $authToken',
  };

  // Send DELETE request to delete the book with the given ID
  final response = await http.delete(
    Uri.parse('$baseUrl/users/orders?id=$bookId/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    print('Book deleted successfully: ${response.statusCode}');
    showMessage("Deleted Successfully");
    // Book successfully deleted, reload the HomeScreen
    Navigator.pop(context); // Pop the CartScreen
    Navigator.pushReplacement( // Push a new instance of HomeScreen
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } else {
    // Handle error
    print('Failed to delete book. Status code: ${response.statusCode}');
    showMessage("Something went wrong!");
  }
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

  // Method to calculate total item count
  void calculateTotalItemCount() {
    totalItemCount = 0;
    if (orders.isNotEmpty) {
      for (var order in orders) {
        if (order.containsKey('items')) {
          totalItemCount += (order['items'] as List<dynamic>).length;
        }
      }
    }
    print('Total Item Count: $totalItemCount');
  }

  // Method to check payment method
  Widget getCheckoutButton() {
    try {
      if (user.paymenttype == 'paypal') {
        // If payment type is PayPal, display PayPalButton
        return const PayPalButton();
      } else if (user.paymenttype == 'mpesa') {
        // Display the checkout button for M-Pesa
        return const MpesaButton();
      } else {
        // If payment type is neither PayPal nor M-Pesa, return an error
        print('Error: Unsupported');
        return const Text(
          '',
          style: TextStyle(color: Colors.red),
        );
      }
    } catch (e) {
      // Handle any exceptions that might occur during the process
      print('Error: $e');
      return Text(
        'Error: $e',
        style: const TextStyle(color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppProvider>(context, listen: false).user;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 130,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total",
                        style: appstyleWithHt(
                            16, AppColors.black, FontWeight.w600, 1.0),
                      ),
                      Text(
                        "Ksh $totalAmount",
                        style: appstyle(15, AppColors.black, FontWeight.w400),
                      ),
                    ],
                  ),
                  const MpesaButton()
                  //  getCheckoutButton()
                ],
              ),
              const SizedBox(
                height: 6,
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBackButton(),
        backgroundColor: Colors.white,
        title: Text(
          "Cart ($totalItemCount items)",
          style: appstyleWithHt(18, AppColors.black, FontWeight.bold, 1.5),
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Column(
            children: order['items'].map<Widget>((item) {
              final book = item['book'];
              // Calculate the subtotal for each item
              double subtotal = book['price'].toDouble() * item['quantity'];
              // Add the subtotal to the total amount
              totalAmount += subtotal;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xff3249CA), width: 3),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: Image.network(
                              book['path'],
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 140,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          book['title'],
                                          style: appstyle(13, AppColors.black,
                                              FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            'Ksh ${book['price'].toDouble()}',
                                            style: appstyle(15, AppColors.black,
                                                FontWeight.w600),
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            ' x ${item['quantity']}',
                                            style: appstyle(14, AppColors.black,
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 50),
                                      InkWell(
                                        onTap: () {
                                          // Get the ID of the book to be deleted
                                          int bookIdToDelete =
                                              item['book']['id'];
                                          // Call a method to delete the book
                                          deleteBookFromCart(bookIdToDelete);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color(0xff3249CA),
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
