import 'dart:convert';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  final String id;
  final int quantity;
  late List<dynamic> orders = [];
  static int totalItemCount = 0;
  static Set<String> placedOrderIds = {};

  Order({required this.id, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
    };
  }
}

Future<void> placeOrder(String id, int quantity) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('x-auth-token');

  if (authToken == null) {
    throw Exception('Token not found. User may not be logged in.');
  }

  try {
    // Prepare the data to be sent in the request body
    Map<String, dynamic> requestBody = {
      "id": id,
      "quantity": quantity,
    };

    // Convert the request body to JSON
    String jsonBody = jsonEncode(requestBody);

    // Make the POST request to make an order
    final response = await http.post(
      Uri.parse('$baseUrl/users/orders/'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Handle success
      print('Order placed successfully');
      
      // Fetch updated orders data
      await fetchData();

    } else {
      // Handle error
      print('Failed to place order: ${response.statusCode}');
      throw Exception('Failed to place order');
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during order placement: $e');
    throw Exception('Failed to place order');
  }
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
      // Handle success
      print('Order fecthed successfully');
      

      } else {
        print('Exception during order placement: ${response.body}');
        throw Exception('Failed to load orders');
      }
    }
  


// Future<void> placeOrder(String id, int quantity) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? authToken = prefs.getString('x-auth-token');

//   if (authToken == null) {
//     throw Exception('Token not found. User may not be logged in.');
//   }

//   try {
//     // Prepare the data to be sent in the request body
//     Map<String, dynamic> requestBody = {
//       "id": id,
//       "quantity": quantity,
//     };

//     // Convert the request body to JSON
//     String jsonBody = jsonEncode(requestBody);

//     // Make the POST request to make an order
//     final response = await http.post(
//       Uri.parse('$baseUrl/users/orders/'),
//       headers: <String, String>{
//         'Authorization': 'Bearer $authToken',
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonBody,
//     );

//     // Check if the request was successful (status code 200)
//     if (response.statusCode == 200) {
//       // Handle success
//       print('Order placed successfully');
      
//     } else {
//       // Handle error
//       print('Failed to place order: ${response.statusCode}');
//       throw Exception('Failed to place order');
//     }
//   } catch (e) {
//     // Handle exceptions
//     print('Exception during order placement: $e');
//     throw Exception('Failed to place order');
//   }
// }