import 'dart:convert';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:http/http.dart' as http;

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.description,
    this.qty,
  });

  String image;
  String id;
  String title;
  double price;
  String subtitle;
  String description;
  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"].toString(),
      title: json["title"] ?? "",
      subtitle: json["subtitle"] ?? "",
      description: json["description"] ?? "",
      image: json["path"] ?? "",
      qty: json["quantity"],
      price:
          json["price"] != null ? double.parse(json["price"].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "image": image,
      "subtitle": subtitle,
      "description": description,
      "price": price,
      "qty": qty,
    };
  }

  ProductModel copyWith({
    int? qty,
  }) {
    return ProductModel(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      image: image,
      qty: qty ?? this.qty,
      price: price,
    );
  }
}

Future<List<ProductModel>> fetchProducts() async {
  final response = await http.get(
    Uri.parse('$baseUrl/books/'),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    List<dynamic> data = responseData['data'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
