// import 'dart:convert';

// import 'package:destiny_capsules/constants/appstyle.dart';
// import 'package:destiny_capsules/constants/colors.dart';
// import 'package:destiny_capsules/constants/constants.dart';
// import 'package:destiny_capsules/provider/app_provider.dart';
// import 'package:destiny_capsules/screens/cart/cart_screen.dart';
// import 'package:destiny_capsules/screens/podplayer/pod_player_screen.dart';
// import 'package:destiny_capsules/screens/blogs/blogs_screen.dart';
// import 'package:destiny_capsules/screens/profile/profile_screen.dart';
// import 'package:destiny_capsules/screens/search/search_screen.dart';
// import 'package:destiny_capsules/common_widgets/app_icons_buttons/app_icons_button.dart';
// import 'package:destiny_capsules/common_widgets/app_icons_buttons/back_button.dart';
// import 'package:destiny_capsules/common_widgets/carousel_widget.dart';
// import 'package:destiny_capsules/common_widgets/reusable_widget.dart';
// import 'package:destiny_capsules/common_widgets/products_grid.dart';
// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart';
// import 'package:http/http.dart' as http;
// import 'package:badges/badges.dart' as badges;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// class OnlineCourcesScreen extends StatefulWidget {
//   const OnlineCourcesScreen({super.key});

//   @override
//   State<OnlineCourcesScreen> createState() => _OnlineCourcesScreenState();
// }

// class _OnlineCourcesScreenState extends State<OnlineCourcesScreen> {
//   late List<dynamic> orders = [];
//   int totalItemCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('x-auth-token');

//     if (authToken == null) {
//       throw Exception('Token not found. User may not be logged in.');
//     }

//     final Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $authToken',
//     };

//     final response = await http.get(
//       Uri.parse('$baseUrl/users/orders/'),
//       headers: headers,
//     );

//     if (mounted) {
//       if (response.statusCode == 200) {
//         setState(() {
//           orders = json.decode(response.body)['data'];
//           calculateTotalItemCount(); // Calculate total item count
//         });
//       } else {
//         print('Exception during order placement: ${response.body}');
//         throw Exception('Failed to load orders');
//       }
//     }
//   }

//   // Method to calculate total item count
//   void calculateTotalItemCount() {
//     totalItemCount = 0;
//     if (orders.isNotEmpty) {
//       for (var order in orders) {
//         if (order.containsKey('items')) {
//           totalItemCount += (order['items'] as List<dynamic>).length;
//         }
//       }
//     }
//     print('Total Item Count: $totalItemCount');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: const AppBackButton(),
//         backgroundColor: Colors.white,
//         title: Text(
//           "Online-Courses",
//           style: appstyleWithHt(18, AppColors.black, FontWeight.bold, 1.5),
//         ),
//         actions: [
//           Row(
//             children: [
//               AppIconsButton(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SearchScreen(),
//                     ),
//                   );
//                 },
//                 iconData: Icons.search_outlined,
//                 iconColor: Colors.black,
//               ),
//               const SizedBox(
//                 width: 9,
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const CartScreen(),
//                     ),
//                   );
//                 },
//                 child: Center(
//                   child: badges.Badge(
//                     showBadge: true,
//                     badgeContent: Consumer<AppProvider>(
//                       builder: (context, value, child) {
//                         return Text(
//                           "$totalItemCount",
//                           style: appstyle(14, AppColors.white, FontWeight.w400),
//                         );
//                       },
//                     ),
//                     animationType: BadgeAnimationType.fade,
//                     animationDuration: const Duration(milliseconds: 300),
//                     child: const Icon(
//                       Icons.shopping_cart_outlined,
//                       color: Colors.black,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 9,
//               ),
//               AppIconsButton(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ProfileScreen(),
//                     ),
//                   );
//                 },
//                 iconData: Icons.person_2_outlined,
//                 iconColor: Colors.black,
//               ),
//               const SizedBox(
//                 width: 9,
//               ),
//               AppIconsButton(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PodPlayerScreen(),
//                     ),
//                   );
//                 },
//                 iconData: Icons.more_vert_outlined,
//                 iconColor: Colors.black,
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CarouselWidget(
//                   imagePaths: const [
//                     'assets/img/watching.png',
//                   ],
//                   titles: const [
//                     'Online Courses',
//                   ],
//                   onBackPressed: [
//                     () {
//                       Navigator.pop(context);
//                     },
//                   ],
//                   onForwardPressed: [
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PodcastScreen(),
//                         ),
//                       );
//                     },
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 SizedBox(
//                   width: 235,
//                   height: 30,
//                   child: Text(
//                     'Featured Courses',
//                     style: appstyle(18, AppColors.primaryText, FontWeight.w700),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 ReusableWidget(
//                   labelText: 'Personal Development',
//                   onPressed: () {},
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 const ProductGrid(),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 80,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//           child: ReusableWidget(
//             labelText: 'Bible Exposition',
//             onPressed: () {},
//           ),
//         ),
//       ),
//     );
//   }
// }
