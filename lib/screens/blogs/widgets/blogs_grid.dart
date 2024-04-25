import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/models/blogs_model/blogs_model.dart';
import 'package:destiny_capsules/screens/blogs_singleitem_screen/blogs_singleitem_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BlogsGrid extends StatefulWidget {
  const BlogsGrid({super.key});

  @override
  _BlogsGridState createState() => _BlogsGridState();
}

class _BlogsGridState extends State<BlogsGrid> {
  late Future<List<BlogsModel>> futureBlogs;

  @override
  void initState() {
    super.initState();
    futureBlogs = fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BlogsModel>>(
      future: futureBlogs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xff3249CA),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Product is empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return _buildProductGrid(snapshot.data!);
        }
      },
    );
  }

  Widget _buildProductGrid(List<BlogsModel> products) {
    final media = MediaQuery.of(context).size;
    return MasonryGridView.builder(
      padding: const EdgeInsets.only(bottom: 15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: products.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (ctx, index) {
        final singleBlog = products[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BlogsDetailsScreen(singleBlog: singleBlog),
                ),
              );
            },
            child: Center(
              child: Container(
                width: media.width * 0.4,
                height: media.height * 0.38,
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 10,
                  right: 10,
                  bottom: 18,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x1E000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          singleBlog.coverImage,
                          width: media.width * 0.35,
                          height: media.height * 0.15,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xff3249CA)),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Text(
                      singleBlog.title,
                      style: appstyle(12, AppColors.black, FontWeight.w600),
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Text(
                      singleBlog.description,
                      style: appstyle(12, AppColors.black, FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
