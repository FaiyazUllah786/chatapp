import 'package:chatapp/common/message_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(
      {required this.message, required this.isMe, required this.messageEnum});
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
