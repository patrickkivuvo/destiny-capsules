import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/screens/blogs/blogs_screen.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/screens/cart/cart_screen.dart';
import 'package:destiny_capsules/screens/search/search_screen.dart';
import 'package:destiny_capsules/screens/profile/profile_screen.dart';
import 'package:destiny_capsules/common_widgets/app_icons_buttons/app_icons_button.dart';
import 'package:destiny_capsules/common_widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/app_icons_buttons/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> orders = [];
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

    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body)['data'];
          calculateTotalItemCount(); // Calculate total item count
        });
      } else {
        print('Exception during order placement: ${response.body}');
        throw Exception('Failed to load orders');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppLogoIcon(),
        backgroundColor: Colors.white,
        title: Text(
          "Home",
          style: appstyleWithHt(18, AppColors.black, FontWeight.bold, 1.5),
        ),
        actions: [
          Row(
            children: [
              AppIconsButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const  SearchScreen(),
                    ),
                  );
                },
                iconData: Icons.search_outlined,
                iconColor: Colors.black,
              ),
              const SizedBox(
                width: 9,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                child: Center(
                  child: badges.Badge(
                    showBadge: true,
                    badgeContent: Consumer<AppProvider>(
                      builder: (context, value, child) {
                        return Text(
                          "$totalItemCount",
                          style: appstyle(14, AppColors.white, FontWeight.w400),
                        );
                      },
                    ),
                    animationType: BadgeAnimationType.fade,
                    animationDuration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              AppIconsButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                iconData: Icons.person_2_outlined,
                iconColor: Colors.black,
              ),
              const SizedBox(
                width: 9,
              ),
              AppIconsButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlogScreen(),
                    ),
                  );
                },
                iconData: Icons.calendar_today_outlined,
                iconColor: Colors.black,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 95,
                    left: 15,
                    right: 130,
                    bottom: 2,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/img/reading.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                      width: 100,
                      height: 35,
                      child: Text(
                        'E-Books',
                        style: appstyle(14, AppColors.white, FontWeight.w400),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      height: 120,
                      padding: const EdgeInsets.only(
                        top: 89,
                        left: 8,
                        right: 2,
                        bottom: 2,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/img/podcast.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'Podcasts',
                        style: appstyle(14, AppColors.black, FontWeight.w400),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 120,
                      padding: const EdgeInsets.only(
                        top: 89,
                        left: 8,
                        right: 2,
                        bottom: 2,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/img/lap.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'Digital Resources',
                        style: appstyle(14, AppColors.black, FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 95,
                    left: 15,
                    right: 130,
                    bottom: 2,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/img/services5.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: 35,
                    child: SizedBox(
                      width: 188,
                      height: 30,
                      child: Text(
                        'Learn Online Courses',
                        style: appstyle(16, AppColors.black, FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Most Popular',
                  style: appstyle(18, AppColors.primary, FontWeight.w700),
                ),
                // const SizedBox(
                //   height: 12,
                // ),
                // ReusableWidget(
                //   labelText: 'Featured E-books',
                //   onPressed: () {
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => const EBooksScreen(),
                //     //   ),
                //     // );
                //   },
                // ),
                const SizedBox(
                  height: 12,
                ),
                const ProductGrid(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
