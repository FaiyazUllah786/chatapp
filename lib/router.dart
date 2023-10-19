import 'package:chatapp/features/auth/screens/otp_screen.dart';
import 'package:chatapp/features/auth/screens/userInformation_screen.dart';
import 'package:chatapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:chatapp/screens/mobile_chat_screen.dart';
import 'package:chatapp/screens/mobile_layout_screen.dart';
import 'package:flutter/material.dart';
import './features/auth/screens/login_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      return MaterialPageRoute(builder: (context) => const MobileChatScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: ErrorWidget("This page does not exist"),
              ));
  }
}