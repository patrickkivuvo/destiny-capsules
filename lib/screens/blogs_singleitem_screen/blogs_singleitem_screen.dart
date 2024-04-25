import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/models/blogs_model/blogs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BlogsDetailsScreen extends StatefulWidget {
  final BlogsModel singleBlog;
  const BlogsDetailsScreen({super.key, required this.singleBlog});

  @override
  State<BlogsDetailsScreen> createState() => _BlogsDetailsScreenState();
}

class _BlogsDetailsScreenState extends State<BlogsDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: media.height * 0.18,
                      child: Image.network(
                        widget.singleBlog.coverImage,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.01,
                  ),
                  Container(
                    width: media.width * 0.12,
                    height: media.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: media.width * 0.08,
                        height: media.height * 0.06,
                        child: Image.network(
                          widget.singleBlog.coverImage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: media.height * 0.48,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40.00,
                  ),
                  Text(
                    widget.singleBlog.title,
                    style: appstyle(18, AppColors.black, FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 2.00,
                  ),
                  Text(
                    widget.singleBlog.description,
                    style: appstyle(16, AppColors.black, FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 2.00,
                  ),
                  HtmlWidget(
                    widget.singleBlog.body,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
