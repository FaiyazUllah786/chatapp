import 'package:chatapp/colors.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/cutom_button.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  Country? _country;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        useSafeArea: true,
        context: context,
        countryListTheme: const CountryListThemeData(
            bottomSheetHeight: 500,
            backgroundColor: backgroundColor,
            flagSize: 30,
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        onSelect: (Country country) {
          setState(() {
            _country = country;
          });
        });
  }

  void sendPhoneNumber() async {
    String phoneNumber = phoneController.text.trim();
    phoneFocus.unfocus();
    if (_country != null && phoneNumber.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${_country!.phoneCode}$phoneNumber');
      setState(() {
        _isLoading = false;
      });
    } else if (_country == null) {
      showSnackBar(context: context, content: "select Your Country");
    } else if (phoneNumber.isEmpty) {
      showSnackBar(context: context, content: "Enter Your Phone Number");
    } else {
      showSnackBar(context: context, content: "Something Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Enter Your Mobile Number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("WhatsApp will need to verify your phone number."),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: pickCountry,
              label: _country != null
                  ? Text(
                      _country!.name,
                      overflow: TextOverflow.fade,
                    )
                  : const Text("Pick Country"),
              icon: const Icon(Icons.arrow_drop_down),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _country != null
                    ? Container(
                        decoration: BoxDecoration(
                            color: tabColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("+${_country!.phoneCode}")),
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            color: tabColor,
                            borderRadius: BorderRadius.circular(10)),
                        height: 40,
                        child: const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            '000',
                            style: TextStyle(fontSize: 16),
                          )),
                        )),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    focusNode: phoneFocus,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: "Phone Number"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CustomLoadinIndicator(),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 100,
              child: CustomButton(
                onPressed: sendPhoneNumber,
                text: "NEXT",
              ),
            )
          ],
        ),
      ),
    );
  }
}
