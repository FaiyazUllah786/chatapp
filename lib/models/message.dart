import '../common/message_enum.dart';

class Message {
  final String recieverId;
  final String senderId;
  final String text;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.recieverId,
    required this.senderId,
    required this.text,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'text': text,
      'messageType': messageType.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        recieverId: map['recieverId'],
        senderId: map['senderId'],
        text: map['text'],
        messageType: (map['messageType'] as String).toEnum(),
        timeSent: map['timeSent'].toDate(),
        messageId: map['messageId'],
        isSeen: map['isSeen'],
        repliedMessage: map['repliedMessage'],
        repliedTo: map['repliedTo'],
        repliedMessageType: (map['repliedMessageType'] as String).toEnum());
  }
}
