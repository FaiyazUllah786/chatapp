import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/cutom_button.dart';
import 'package:chatapp/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void navigateToLoginScreen(BuildContext context) {
      try {
        Navigator.pushNamed(context, LoginScreen.routeName);
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Welcome To WhatsApp",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: size.height / 9),
              Image.asset(
                "assets/bg.png",
                color: tabColor,
                width: 340,
                height: 340,
              ),
              SizedBox(height: size.height / 9),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read Our Privacy Policy.Tap "Agree and Continue" to accept the Terms of Service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: greyColor),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                      text: 'AGREE AND CONTINUE',
                      onPressed: () => navigateToLoginScreen(context))),
            ],
          ),
        ),
      ),
    );
  }
}
