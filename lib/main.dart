import 'package:chatapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'colors.dart';
import './router.dart';
import './screens/mobile_layout_screen.dart';
import './features/landing/screens/landing_screen.dart';
import './common/widgets/custom_loading_indicator.dart';
import './common/widgets/error.dart';
import './features/auth/controller/auth_controller.dart';
import 'screens/web_layout_screen.dart';
import 'utils/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatApp",
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(color: appBarColor)),
      home: const SelectContactScreen(),
      // home: ref.watch(userDataAuthProvider).when(
      //     data: (user) {
      //       if (user == null) {
      //         return const LandingScreen();
      //       }
      //       return const MobileLayoutScreen();
      //     },
      //     error: (err, trace) {
      //       return ErrorScreen(error: err.toString());
      //     },
          // loading: () => const CustomLoadinIndicator()),
      onGenerateRoute: (settings) => onGenerateRoute(settings),
    );
  }
}
