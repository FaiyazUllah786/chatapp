import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:chatapp/features/status/controller/status_contoller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStatusScreen extends ConsumerStatefulWidget {
  static const routeName = '/confirm-status-screen';
  final File file;
  const ConfirmStatusScreen({super.key, required this.file});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmStatusScreenState();
}

class _ConfirmStatusScreenState extends ConsumerState<ConfirmStatusScreen> {
  bool _isStatusUploading = false;

  void addStatus(WidgetRef ref, BuildContext context) async {
    setState(() {
      _isStatusUploading = true;
    });
    await ref.read(statusControllerProvider).addStatus(widget.file, context);
    setState(() {
      _isStatusUploading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Image.file(widget.file),
            ),
          ),
          if (_isStatusUploading)
            Center(
              child: CircularProgressIndicator(color: whiteColor),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(ref, context),
        // onPressed: () {
        //   setState(() {
        //     _isStatusUploading = !_isStatusUploading;
        //   });
        // },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}

// class ConfirmStatusScreen extends ConsumerWidget {
//   static const routeName = '/confirm-status-screen';
//   final File file;
//   ConfirmStatusScreen({super.key, required this.file});

//   bool _isStatusUploading = false;

//   void addStatus(WidgetRef ref, BuildContext context) async {
//     _isStatusUploading = true;
//     await ref.read(statusControllerProvider).addStatus(file, context);
//     _isStatusUploading = false;
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: AspectRatio(
//               aspectRatio: 9 / 16,
//               child: Image.file(file),
//             ),
//           ),
//           if (_isStatusUploading) CircularProgressIndicator(),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => addStatus(ref, context),
//         backgroundColor: tabColor,
//         child: const Icon(
//           Icons.done,
//           color: whiteColor,
//         ),
//       ),
//     );
//   }
// }
