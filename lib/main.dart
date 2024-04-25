
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/screens/auth_ui/login/login_screen.dart';
import 'package:destiny_capsules/screens/home/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: ((context) => AppProvider()),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            brightness: Brightness.light,
          ),
          home: FutureBuilder<void>(
            future: appProvider.checkLoggedIn(),
            builder: (context, snapshot) {
              return appProvider.isLoggedIn ? const HomeScreen() : const LogInScreen();
            },
          ),
        );
      },
    );
  }
}
