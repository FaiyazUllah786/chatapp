import 'dart:io';

import 'package:chatapp/features/auth/screens/account_info_screen.dart';
import 'package:chatapp/features/auth/screens/otp_screen.dart';
import 'package:chatapp/features/auth/screens/userInformation_screen.dart';
import 'package:chatapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:chatapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:chatapp/features/status/screens/confirm_status_screen.dart';
import 'package:chatapp/features/status/screens/status_screen.dart';
import 'package:chatapp/screens/mobile_layout_screen.dart';
import 'package:flutter/material.dart';
import './features/auth/screens/login_screen.dart';
import 'models/status.dart';

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
    case AccountInfoScreen.routeName:
      return MaterialPageRoute(builder: (context) => AccountInfoScreen());
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(name: name, uid: uid));
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(file: file));
    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(status: status));
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: ErrorWidget("This page does not exist"),
              ));
  }
}
