// import 'package:destiny_capsules/constants/constants.dart';
// import 'package:destiny_capsules/screens/profile/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:destiny_capsules/constants/colors.dart';
// import 'package:destiny_capsules/common_widgets/round_button.dart';
// import 'package:destiny_capsules/common_widgets/round_textfield.dart';
// import 'package:destiny_capsules/models/user_model/user_model.dart';
// import 'package:destiny_capsules/provider/app_provider.dart';

// class EditProfileDialog extends StatefulWidget {
//   const EditProfileDialog({Key? key}) : super(key: key);

//   @override
//   _EditProfileDialogState createState() => _EditProfileDialogState();
// }

// class _EditProfileDialogState extends State<EditProfileDialog> {
//   late TextEditingController txtName;
//   late TextEditingController txtLastName;
//   late TextEditingController txtMobile;
//   late TextEditingController txtEmail;

//   bool isLoading = false; // Track loading state

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the text controllers with current user data
//     User user = Provider.of<AppProvider>(context, listen: false).user;
//     txtName = TextEditingController(text: user.firstname);
//     txtLastName = TextEditingController(text: user.lastname);
//     txtMobile = TextEditingController(text: user.mobile);
//     txtEmail = TextEditingController(text: user.email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 15 * 3,
//           horizontal: 15,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RoundTextfield(
//               hintText: "First Name",
//               controller: txtName,
//               keyboardType: TextInputType.name,
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             RoundTextfield(
//               hintText: "Last Name'",
//               controller: txtLastName,
//               keyboardType: TextInputType.name,
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             RoundTextfield(
//               hintText: "Phone Number",
//               controller: txtMobile,
//               keyboardType: TextInputType.phone,
//               prefixIcon: const SizedBox(
//                 width: 14,
//                 height: 14,
//                 child: Icon(
//                   Icons.add,
//                   size: 14,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             RoundTextfield(
//               hintText: "Email Address",
//               controller: txtEmail,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(
//               height: 25,
//             ),
//             isLoading
//                 ? const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Color(0xff3249CA),
//                     ),
//                   ) // Show CircularProgressIndicator while loading
//                 : RoundButton(
//                     foregroundColor: AppColors.white,
//                     backgroundColor: AppColors.black,
//                     buttonText: 'Continue',
//                     onPressed: () async {
//                       setState(() {
//                         isLoading = true; // Start loading
//                       });
//                       // Create a new User object with updated data
//                       User updatedUser = User(
//                         firstname: txtName.text,
//                         lastname: txtLastName.text,
//                         mobile: txtMobile.text,
//                         email: txtEmail.text,
//                         paymenttype:
//                             Provider.of<AppProvider>(context, listen: false)
//                                 .user
//                                 .paymenttype, // Keep the existing paymenttype
//                       );
//                       // Call the updateUserData method
//                       User? updatedUserData = await updateUserData(updatedUser);
//                       if (updatedUserData != null) {
//                         showMessage("Successfully Updated!!");
//                         Navigator.pop(context);
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ProfileScreen(),
//                           ),
//                         );
//                       } else {
//                         showMessage("Failed to update user data");
//                       }
//                       setState(() {
//                         isLoading = false; // End loading
//                       });
//                     },
//                   ),
//             const SizedBox(
//               height: 15,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:destiny_capsules/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:destiny_capsules/common_widgets/round_button.dart';
import 'package:destiny_capsules/common_widgets/round_textfield.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/constants/colors.dart';


class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController txtName;
  late TextEditingController txtLastName;
  late TextEditingController txtMobile;
  late TextEditingController txtEmail;

  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with current user data
    User user = Provider.of<AppProvider>(context, listen: false).user;
    txtName = TextEditingController(text: user.firstname);
    txtLastName = TextEditingController(text: user.lastname);
    txtMobile = TextEditingController(text: user.mobile);
    txtEmail = TextEditingController(text: user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15 * 3,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundTextfield(
              hintText: "First Name",
              controller: txtName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Last Name'",
              controller: txtLastName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Phone Number",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
              prefixIcon: const SizedBox(
                width: 14,
                height: 14,
                child: Icon(
                  Icons.add,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Email Address",
              controller: txtEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 25,
            ),
            isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff3249CA),
                    ),
                  ) // Show CircularProgressIndicator while loading
                : RoundButton(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.black,
                    buttonText: 'Continue',
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Start loading
                      });
                      // Create a new User object with updated data
                      User updatedUser = User(
                        firstname: txtName.text,
                        lastname: txtLastName.text,
                        mobile: txtMobile.text,
                        email: txtEmail.text,
                        paymenttype:
                            Provider.of<AppProvider>(context, listen: false)
                                .user
                                .paymenttype, // Keep the existing paymenttype
                      );

                      // Call the updateUserData method
                      User? updatedUserData = await updateUserData(updatedUser);
                      if (updatedUserData != null) {
                        showMessage("Successfully Updated!!");
                        Navigator.pop(context);
                      } else {
                        // Check if the failure was due to email or phone number conflict
                         bool phoneExists = await Provider.of<AppProvider>(context, listen: false).checkPhoneNumberExists(txtMobile.text);
                        bool emailExists = await Provider.of<AppProvider>(context, listen: false).checkEmailExists(txtEmail.text);
                       
                        if(emailExists) {
                          showMessage1("The specified Phone Number is already associated with another account");
                        } else if(phoneExists) {
                          showMessage1("The specified Email is already associated with another account");
                        } else {
                          showMessage1("Failed to update user data");
                        }
                      }
                      setState(() {
                        isLoading = false; // End loading
                      });
                    },
                  ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

   void showMessage1(String message) {
    // Show message to the user using AlertDialog or SnackBar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
