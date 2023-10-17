import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerStatefulWidget {
  static const String routeName = "/otp-screen";
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  bool _isLoading = false;
  void _verifyOTP(
      {WidgetRef? ref, BuildContext? context, String? userOTP}) async {
    setState(() {
      _isLoading = true;
    });
    await ref!
        .read(authControllerProvider)
        .verifyOtp(context!, widget.verificationId, userOTP!);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying you number"),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("We have sent an SMS with Code"),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(fontSize: 30),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    _verifyOTP(context: context, ref: ref, userOTP: val.trim());
                  } else {
                    print("this func is running");
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Didn't recieve an OTP?"),
                TextButton(onPressed: () {}, child: const Text("resend"))
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CustomLoadinIndicator()
          ],
        ),
      ),
    );
  }
}

// class OTPScreen extends ConsumerWidget {
//   static const String routeName = "/otp-screen";
//   final String verificationId;
//   const OTPScreen({super.key, required this.verificationId});

//   void _verifyOTP({WidgetRef? ref, BuildContext? context, String? userOTP}) {
//     ref!
//         .read(authControllerProvider)
//         .verifyOtp(context!, verificationId, userOTP!);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Verifying you number"),
//         backgroundColor: backgroundColor,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text("We have sent an SMS with Code"),
//             SizedBox(
//               width: size.width * 0.5,
//               child: TextField(
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   hintText: "- - - - - -",
//                   hintStyle: TextStyle(fontSize: 30),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   if (val.length == 6) {
                    
//                     _verifyOTP(context: context, ref: ref, userOTP: val.trim());
//                   } else {
//                     print("this func is running");
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Text("Didn't recieve an OTP?"),
//                 TextButton(onPressed: () {}, child: const Text("resend"))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
