import '../common/message_enum.dart';

class Message {
  final String recieverId;
  final String senderId;
  final String text;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message(
      {required this.recieverId,
      required this.senderId,
      required this.text,
      required this.messageType,
      required this.timeSent,
      required this.messageId,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'text': text,
      'messageType': messageType.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        recieverId: map['recieverId'],
        senderId: map['senderId'],
        text: map['text'],
        messageType: (map['messageType'] as String).toEnum(),
        timeSent: map['timeSent'],
        messageId: map['messageId'],
        isSeen: map['isSeen']);
  }
}
