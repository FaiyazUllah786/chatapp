import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/error.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  static const String routeName = '/account-info';
  const AccountInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  File? profileImage;
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: StreamBuilder(
            stream: ref.watch(authControllerProvider).getCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const CustomLoadinIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorScreen(error: snapshot.error.toString()),
                );
              } else {
                var data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data.profilePic),
                            radius: 100,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: backgroundColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Profile Photo',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  profileImage =
                                                      await pickImageFromGallery(
                                                          context);
                                                  await ref
                                                      .read(
                                                          authControllerProvider)
                                                      .updateUserProfilePicToFirestore(
                                                          context: context,
                                                          profilePic:
                                                              profileImage);
                                                  print(
                                                      'update profile pic done');
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(18.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .photo_size_select_actual_outlined,
                                                        size: 50,
                                                        color: tabColor,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  profileImage =
                                                      await pickImageFromCamera(
                                                          context);
                                                  await ref
                                                      .read(
                                                          authControllerProvider)
                                                      .updateUserProfilePicToFirestore(
                                                          context: context,
                                                          profilePic:
                                                              profileImage);
                                                  print(
                                                      'update profile pic done');
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(18.0),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        size: 50,
                                                        color: tabColor,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: tabColor,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.person, size: 30),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: tabColor),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: backgroundColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 18,
                                    right: 18,
                                    top: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Enter Your Name',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          hintText: data.name,
                                          focusColor: tabColor,
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: tabColor,
                                                      width: 3))),
                                      onChanged: (value) {
                                        name = value;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: tabColor,
                                                  fontSize: 16),
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(authControllerProvider)
                                                  .updateUserNameToFirestore(
                                                      context: context,
                                                      name: name);
                                              // setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: tabColor,
                                                  fontSize: 16),
                                            ))
                                      ],
                                    ),
                                    // Container(
                                    //   height: 100,
                                    //   color: tabColor,
                                    // ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Phone",
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          const SizedBox(height: 5),
                          Text(
                            data.phoneNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              }
            }));
  }
}
