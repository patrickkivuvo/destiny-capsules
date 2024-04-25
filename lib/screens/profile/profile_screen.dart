import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/dialogs/contactus.dart';
import 'package:destiny_capsules/dialogs/edit_profile.dart';
import 'package:destiny_capsules/dialogs/payment_method.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:destiny_capsules/screens/auth_ui/widgets/auth_service.dart';
import 'package:destiny_capsules/screens/orders/orders_screen.dart';
import 'package:destiny_capsules/common_widgets/app_icons_buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<AppProvider>(context).user;
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      User user = appProvider.user;

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const AppBackButton(),
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: appstyleWithHt(18, AppColors.black, FontWeight.bold, 1.5),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Text(
                  user.firstname ?? "fistname",
                  style: appstyle(18, AppColors.black, FontWeight.w500),
                ),
                Text(
                  user.email ?? 'email',
                  style: appstyle(16, AppColors.black, FontWeight.w400),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  user.mobile ?? 'phone number',
                  style: appstyle(14, AppColors.black, FontWeight.w400),
                ),
                Text(
                  user.paymenttype ?? 'payment',
                  style: appstyle(14, AppColors.black, FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showGeneralDialog(
                        barrierLabel: 'Dialog',
                        barrierDismissible: true,
                        context: context,
                        pageBuilder: (ctx, anim1, anim2) =>
                            const EditProfileDialog(),
                        transitionBuilder: (ctx, anim1, anim2, child) =>
                            ScaleTransition(
                          scale: anim1,
                          child: child,
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text("Edit Profile",
                        style: appstyle(14, AppColors.black, FontWeight.w400)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showGeneralDialog(
                        barrierLabel: 'Dialog',
                        barrierDismissible: true,
                        context: context,
                        pageBuilder: (ctx, anim1, anim2) => PaymentDialog(
                          onPaymentTypeChanged:
                              handlePaymentTypeChange, // Pass callback
                        ),
                        transitionBuilder: (ctx, anim1, anim2, child) =>
                            ScaleTransition(
                          scale: anim1,
                          child: child,
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.money_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text("Change Payment Types",
                        style: appstyle(14, AppColors.black, FontWeight.w400)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      "Orders",
                      style: appstyle(14, AppColors.black, FontWeight.w400),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      bool loggedOut =
                          await AuthService.logOutUser(context: context);
                      if (loggedOut) {
                      } else {
                        // Handle logout failure
                      }
                    },
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      "Log out",
                      style: appstyle(14, AppColors.black, FontWeight.w400),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showGeneralDialog(
                        barrierLabel: 'Dialog',
                        barrierDismissible: true,
                        context: context,
                        pageBuilder: (ctx, anim1, anim2) =>
                            const ContactUsDialog(),
                        transitionBuilder: (ctx, anim1, anim2, child) =>
                            ScaleTransition(
                          scale: anim1,
                          child: child,
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.headset_mic_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      "Contact Us",
                      style: appstyle(14, AppColors.black, FontWeight.w400),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
