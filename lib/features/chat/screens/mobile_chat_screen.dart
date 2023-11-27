import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/chat/screens/reciever_info.dart';
import 'package:chatapp/screens/mobile_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../colors.dart';
import '../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/chat-screen';
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;
  const MobileChatScreen(
      {super.key,
      required this.name,
      required this.uid,
      required this.profilePic,
      required this.isGroupChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, MobileLayoutScreen.routeName, (route) => false),
        ),
        backgroundColor: appBarColor,
        title: StreamBuilder(
          stream: ref.read(authControllerProvider).getUserDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            return InkWell(
              onTap: () {
                if (snapshot.hasData) {
                  Navigator.pushNamed(context, RecieverInfo.routeName,
                      arguments: {'usermodel': snapshot.data});
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                      ),
                      if (snapshot.hasData)
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: snapshot.data!.isOnline
                                      ? Colors.green
                                      : Colors.red,
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                            ))
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          name,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      if (snapshot.hasData)
                        Text(
                          'Last Seen:${DateFormat("d MMM h:mm a").format(snapshot.data!.lastSeen).toString()}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: greyColor),
                        )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.video_call),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.call),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert),
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverUserId: uid, isGroupChat: isGroupChat),
          ),
          BottomChatField(recieverUserId: uid, isGroupChat: isGroupChat),
        ],
      ),
    );
  }
}
