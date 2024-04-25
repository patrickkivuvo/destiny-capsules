import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/dialogs/forgot_password.dart';
import 'package:destiny_capsules/screens/auth_ui/signup/signup_screen.dart';
import 'package:destiny_capsules/common_widgets/round_button.dart';
import 'package:destiny_capsules/common_widgets/round_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_service.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  bool isShowPassword = true;

  @override
  void dispose() {
    super.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
  }

  void logInUser() {
    AuthService.logInUser(
      context: context,
      email: txtEmail.text,
      password: txtPassword.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 43,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  width: 290,
                  height: 200,
                  padding: const EdgeInsets.only(
                    top: 65,
                    left: 25,
                    right: 130,
                    bottom: 2,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/img/rectangle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                    width: 197,
                    height: 135,
                    child: Text(
                      'Spiritual resources  just for you!',
                      style:
                          appstyle(22, AppColors.primaryText, FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'LogIn',
                  style:
                      appstyle(16, AppColors.secondaryText1, FontWeight.w700),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: 140,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundTextfield(
                  hintText: "Email Address or phone",
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextfield(
                  hintText: "Password",
                  controller: txtPassword,
                  obscureText: isShowPassword,
                  suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
                InkWell(
                  onTap: () {
                    showGeneralDialog(
                      barrierLabel: 'Dialog',
                      barrierDismissible: true,
                      context: context,
                      pageBuilder: (ctx, anim1, anim2) =>
                          const ForgotPasswordDialog(),
                      transitionBuilder: (ctx, anim1, anim2, child) =>
                          ScaleTransition(
                        scale: anim1,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Forgot Password',
                        style: appstyle(16, AppColors.black, FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RoundButton(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.black,
                  buttonText: 'LogIn',
                  onPressed: () {
                    bool isVaildated =
                        loginValidation(txtEmail.text, txtPassword.text);
                    if (isVaildated) {
                      logInUser();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Don’t have an Account?',
                      style:
                          appstyle(13, AppColors.primaryText, FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3249CA),
                      ),
                      child: Text(
                        'SignUp',
                        style: appstyle(16, AppColors.primary, FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
