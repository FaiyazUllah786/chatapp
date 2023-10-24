import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../widgets/my_message_card.dart';
import '../../../widgets/sender_message_card.dart';
import '../../../common/widgets/custom_loading_indicator.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({Key? key, required this.recieverUserId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          ref.watch(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadinIndicator(); // Display a loading indicator while data is loading.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final messageList = snapshot.data;

          messageList!.sort(
            (a, b) => a.timeSent.compareTo(b.timeSent),
          );

          if (messageList.isEmpty) {
            return const Text('No chat contacts available.');
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              final messageData = messageList[index];
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: DateFormat.jm().format(messageData.timeSent).toString(),
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: DateFormat.jm().format(messageData.timeSent).toString(),
              );
            },
          );
        }
      },
    );
  }
}
