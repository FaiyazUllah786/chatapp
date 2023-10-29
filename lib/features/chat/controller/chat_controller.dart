import 'dart:io';

import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/provider/message_reply_provider.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/chat/repository/chat_repository.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider), ref: ref));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});
  void sendTextMessage(
      BuildContext context, String text, String recieverUserId) async {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((senderUser) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: senderUser!,
            messageReply: messageReply));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserId,
      MessageEnum messageEnum) async {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((senderUser) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: senderUser!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void setChatMessageSeen(
      BuildContext context, String recieverUserId, String messageId) {
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }
}
