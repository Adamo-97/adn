import 'package:flutter/material.dart';
import 'package:Athanapp/screens/info_page_template_en.dart';
import 'package:Athanapp/screens/app_launch_eng.dart';
import 'package:Athanapp/screens/new_password_eng.dart';
import 'package:Athanapp/screens/enter_pin_eng.dart';
import 'package:Athanapp/screens/forgot_password_eng.dart';
import 'package:Athanapp/screens/login_eng.dart';
import 'package:Athanapp/screens/create_account_eng.dart';
import 'package:Athanapp/screens/on_boarding3eng.dart';
import 'package:Athanapp/screens/on_boarding2eng.dart';
import 'package:Athanapp/screens/on_boarding1eng.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),

      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const InfoPageTemplateEN(),
        'app_launch_eng': (BuildContext context) => const AppLaunchENG(),
        'new_password_eng': (BuildContext context) => const NewPasswordENG(),
        'enter_pin_eng': (BuildContext context) => const EnterPinENG(),
        'forgot_password_eng':
            (BuildContext context) => const ForgotPasswordENG(),
        'login_eng': (BuildContext context) => const LoginENG(),
        'create_account_eng':
            (BuildContext context) => const CreateAccountENG(),
        'on_boarding_3_eng': (BuildContext context) => const OnBoarding3ENG(),
        'on_boarding_2_eng': (BuildContext context) => const OnBoarding2ENG(),
        'on_boarding_1_eng': (BuildContext context) => const OnBoarding1ENG(),
      },
    );
  }
}
