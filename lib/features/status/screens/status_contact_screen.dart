import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/features/status/controller/status_contoller.dart';
import 'package:chatapp/features/status/screens/confirm_status_screen.dart';
import 'package:chatapp/features/status/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../models/status.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Status>>(
      stream: ref.read(statusControllerProvider).getStatusStream(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadinIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    File? pickedImage = await pickImageFromGallery(context);
                    if (pickedImage != null) {
                      Navigator.pushNamed(
                          context, ConfirmStatusScreen.routeName,
                          arguments: pickedImage);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.add_a_photo_outlined),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Add Status',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var statusData = snapshot.data![index];
                        return InkWell(
                          onTap: () {
                            print('${statusData.photoUrl.length}');
                            Navigator.pushNamed(context, StatusScreen.routeName,
                                arguments: statusData);
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  statusData.profilePic,
                                ),
                                radius: 24,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                statusData.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
