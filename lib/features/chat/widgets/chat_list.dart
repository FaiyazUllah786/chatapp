import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/provider/message_reply_provider.dart';
import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/custom_loading_indicator.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

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

  void onMessageSwipe(
      {required String message,
      required bool isMe,
      required MessageEnum messageType}) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageType));
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
            return Center(
                child: const Text(
              'No chat contacts available.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ));
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
              if ((!messageData.isSeen) &&
                  (messageData.recieverId ==
                      FirebaseAuth.instance.currentUser!.uid)) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    context, messageData.recieverId, messageData.messageId);
              }
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                    message: messageData.text,
                    date:
                        DateFormat.jm().format(messageData.timeSent).toString(),
                    type: messageData.messageType,
                    repliedText: messageData.repliedMessage,
                    userName: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onLeftSwipe: () => onMessageSwipe(
                          message: messageData.text,
                          isMe: true,
                          messageType: messageData.messageType,
                        ),
                    isSeen: messageData.isSeen);
              }
              return SenderMessageCard(
                message: messageData.text,
                date: DateFormat.jm().format(messageData.timeSent).toString(),
                type: messageData.messageType,
                repliedText: messageData.repliedMessage,
                userName: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  message: messageData.text,
                  isMe: false,
                  messageType: messageData.messageType,
                ),
                isSeen: messageData.isSeen,
              );
            },
          );
        }
      },
    );
  }
}
