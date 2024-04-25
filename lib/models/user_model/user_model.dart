import 'dart:convert';

import 'package:destiny_capsules/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? mobile;
  final String? email;
  final String? profilephoto;
  final String? role;
  String? paymenttype;
  final String? token;
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.profilephoto,
    this.role,
    this.paymenttype,
    this.token,
  });

  // Setter for paymenttype
  void setPaymentType(String type) {
    paymenttype = type;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstname,
      'last_name': lastname,
      'phone_number': mobile,
      'email': email,
      'profile_photo_url': profilephoto,
      'role': role,
      'payment_type': paymenttype,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      firstname: map['first_name'],
      lastname: map['last_name'],
      mobile: map['phone_number'].toString(),
      email: map['email'],
      profilephoto: map['profile_photo_url'],
      role: map['role'],
      paymenttype: map['payment_type'],
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

Future<User?> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('x-auth-token');

  if (authToken == null) {
    throw Exception('Token not found. User may not be logged in.');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/me/'),
    headers: {
      'Authorization': 'Bearer $authToken',
    },
  );

  print('Response: $response');

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    //Its not a list
    return User.fromMap(responseData);
    // Check if 'data' key exists and is not null
  } else {
    print('Failed to load user data: ${response.body}');
    // Show dialog or toast that user data is not available
    return null; // Or return null, depending on your preference
  }
}

Future<User?> updateUserData(User updatedUser) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('x-auth-token');

  if (authToken == null) {
    throw Exception('Token not found. User may not be logged in.');
  }

  final response = await http.patch(
    Uri.parse('$baseUrl/me/'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: json.encode(updatedUser.toMap()),
  );

  print('Response: $response');

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    //Its not a list
    return User.fromMap(responseData);
  } else {
    print('Failed to update user data: ${response.body}');
    // Show dialog or toast that user data could not be updated
    return null; // Or return null, depending on your preference
  }
}
