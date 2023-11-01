import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/features/status/controller/status_contoller.dart';
import 'package:chatapp/features/status/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/status.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadinIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      print('${statusData.photoUrl.length}');
                      Navigator.pushNamed(context, StatusScreen.routeName,
                          arguments: statusData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          statusData.userName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            statusData.profilePic,
                          ),
                          radius: 24,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      },
    );
  }
}
