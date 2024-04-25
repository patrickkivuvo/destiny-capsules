import 'dart:convert';

import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/models/product_model/product_model.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    firstname: '',
    lastname: '',
    mobile: '',
    email: '',
    profilephoto: '',
    role: '',
    paymenttype: '',
  );

    late bool _isLoggedIn = false;

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await checkLoggedIn();
  }

  Future<void> checkLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('x-auth-token');
      _isLoggedIn = authToken != null;
      notifyListeners();
    } catch (e) {
      // Handle errors, such as SharedPreferences access error
      print('Error checking login status: $e');
    }
  }

  User get user => _user;

  bool get isLoggedIn => _isLoggedIn;

  void setUser(String userData) {
    _user = User.fromJson(userData);
    _isLoggedIn = true;
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }

Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token'); // Clear authentication token
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      // Fetch user data to check if the phone number already exists
      User? userData = await fetchUserData();

      if (userData != null) {
        // Check if the provided phone number matches any existing user's phone number
        return userData.mobile == phoneNumber;
      } else {
        // User data not available, return false as phone number doesn't exist
        return false;
      }
    } catch (e) {
      // Error occurred, return false
      print('Error checking phone number existence: $e');
      return false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      // Fetch user data to check if the email already exists
      User? userData = await fetchUserData();

      if (userData != null) {
        // Check if the provided email matches any existing user's email
        return userData.email == email;
      } else {
        // User data not available, return false as email doesn't exist
        return false;
      }
    } catch (e) {
      // Error occurred, return false
      print('Error checking email existence: $e');
      return false;
    }
  }

  List<dynamic> _orders = [];
  int _totalItemCount = 0;

  List<dynamic> get orders => _orders;
  int get totalItemCount => _totalItemCount;

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
      _orders = json.decode(response.body)['data'];
      _calculateTotalItemCount(); // Calculate total item count
      notifyListeners(); // Notify listeners about the change
    } else {
      print('Exception during order placement: ${response.body}');
      throw Exception('Failed to load orders');
    }
  }

  // Method to calculate total item count
  void _calculateTotalItemCount() {
    _totalItemCount = 0;
    if (_orders.isNotEmpty) {
      for (var order in _orders) {
        if (order.containsKey('items')) {
          _totalItemCount += (order['items'] as List<dynamic>).length;
        }
      }
    }
    print('Total Item Count: $_totalItemCount');
  }

//// Cart Work
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  void addCartProduct(ProductModel ProductModel) {
    _cartProductList.add(ProductModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel ProductModel) {
    _cartProductList.remove(ProductModel);
    notifyListeners();
  }

  int get cartItemCount => _cartProductList.length;

  List<ProductModel> get getCartProductList => _cartProductList;

  //////// TOTAL PRICE / // / // / / // / / / // /

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  void updateQty(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    if (index != -1) {
      _cartProductList[index].qty = qty;
      notifyListeners();
    } else {
      showMessage('Product not found in cart!');
    }
  }

  ///////// BUY Product  / / // / / // / / / // /

  void addBuyProductCartList() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getBuyProductList => _buyProductList;
}
