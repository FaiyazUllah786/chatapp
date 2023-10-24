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
    ref.read(userDataAuthProvider).whenData((senderUser) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: senderUser!));
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }
}
