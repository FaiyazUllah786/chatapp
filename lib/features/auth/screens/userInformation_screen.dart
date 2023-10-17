import 'dart:io';

import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/custom_loading_indicator.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = "/user-information";
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();

  File? image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void _storeUserData() async {
    setState(() {
      _isLoading = true;
    });
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      await ref.read(authControllerProvider).saveUserDataToFirestore(
          context: context, name: name, profilePic: image);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? const CustomLoadinIndicator()
          : SafeArea(
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.15),
                    Stack(
                      children: [
                        (image == null)
                            ? const CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS__rdzgGVtykVfE-rpibK1pSf0TKL-r0lmrPpj0Y_NY_smuhAhQaCDnEjWSRPsiYzF1jw&usqp=CAU",
                                ),
                                radius: 100,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 100,
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                              iconSize: 30,
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add_a_photo_rounded)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.85,
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                hintText: "Enter Your Name"),
                          ),
                        ),
                        IconButton(
                            onPressed: _storeUserData,
                            icon: const Icon(Icons.done)),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
