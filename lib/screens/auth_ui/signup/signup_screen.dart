import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/screens/auth_ui/login/login_screen.dart';
import 'package:destiny_capsules/common_widgets/round_button.dart';
import 'package:destiny_capsules/common_widgets/round_textfield.dart';
import 'package:destiny_capsules/screens/auth_ui/widgets/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool isShowPassword = true;
  bool isShowPassword1 = true;
  String _displayText = '';
  double _strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  @override
  void dispose() {
    super.dispose();
    txtName.dispose();
    txtLastName.dispose();
    txtMobile.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
  }

  void _checkPassword(String value) {
    if (txtPassword.text.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '';
      });
    } else if (txtPassword.text.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (txtPassword.text.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(txtPassword.text) ||
          !numReg.hasMatch(txtPassword.text)) {
        setState(() {
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

  void signUpUser() {
    AuthService.signUpUser(
      context: context,
      firstname: txtName.text,
      lastname: txtLastName.text,
      mobile: txtMobile.text,
      email: txtEmail.text,
      password: txtPassword.text,
      confirmpassword: txtConfirmPassword.text,
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
                  height: 12,
                ),
                Text(
                  'SignUp',
                  style:
                      appstyle(16, AppColors.secondaryText1, FontWeight.w400),
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
                  hintText: "First Name",
                  controller: txtName,
                  keyboardType: TextInputType.name,
                  suffixIcon: const Icon(
                    Icons.person,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextfield(
                  hintText: "Last Name'",
                  controller: txtLastName,
                  keyboardType: TextInputType.name,
                  suffixIcon: const Icon(
                    Icons.person,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextfield(
                  hintText: "254",
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
                  suffixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextfield(
                  hintText: "Email Address",
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
                  onChanged: (value) => _checkPassword(value),
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
                const SizedBox(
                  height: 15,
                ),
                LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  color: _strength <= 1 / 4
                      ? Colors.red
                      : _strength == 2 / 4
                          ? Colors.yellow
                          : _strength == 3 / 4
                              ? Colors.blue
                              : Colors.green,
                  minHeight: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  _displayText,
                  style: appstyle(14, AppColors.primaryText, FontWeight.w400),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextfield(
                  hintText: "Confirm Password",
                  controller: txtConfirmPassword,
                  obscureText: isShowPassword1,
                  suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword1 = !isShowPassword1;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isShowPassword1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.primary,
                  buttonText: 'SignUp',
                  onPressed: () {
                    bool isVaildated = signUpValidation(
                        txtName.text,
                        txtLastName.text,
                        txtMobile.text,
                        txtEmail.text,
                        txtPassword.text,
                        txtConfirmPassword.text);
                    if (isVaildated) {
                      signUpUser();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'By signing up, you agree with our ',
                      style:
                          appstyle(12, AppColors.primaryText, FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'Terms & Conditions',
                          style:
                              appstyle(12, AppColors.primary, FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 2,
                  width: double.infinity,
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
                      'Do you already have an account?',
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
                            builder: (context) => const LogInScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3249CA),
                      ),
                      child: Text(
                        'LogIn',
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
