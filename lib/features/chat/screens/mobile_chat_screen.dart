import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/chat-screen';
  String name;
  String uid;
  MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder(
          stream: ref.read(authControllerProvider).getUserDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                if (snapshot.hasData)
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style:
                        const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottomChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}
