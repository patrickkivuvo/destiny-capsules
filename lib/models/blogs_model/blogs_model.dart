import 'dart:convert';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:http/http.dart' as http;



class BlogsModel {
  BlogsModel({
    required this.coverImage,
    required this.id,
    required this.title,
    required this.description,
    required this.body,
  });

  String coverImage;
  String id;
  String title;
  String description;
  String body;

  factory BlogsModel.fromJson(Map<String, dynamic> json) {
    return BlogsModel(
      id: json["id"].toString(),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      coverImage: json["cover_image"] ?? "",
      body: json["body"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "cover_image": coverImage,
      "description": description,
      "body": body,
    };
  }
}

Future<List<BlogsModel>> fetchBlogs() async {
  final response = await http.get(
    Uri.parse('$baseUrl/blogs/'),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    List<dynamic> data = responseData['data'];
    return data.map((json) => BlogsModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Blogss');
  }
}
