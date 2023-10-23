import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts; // Return the list of ChatContact objects.
    });
  }

  void _saveDataToContactSubcollection({
    required UserModel senderUserData,
    required UserModel recieverUserData,
    required String text,
    required DateTime timeSent,
    required String recieverUserId,
  }) async {
    //user -> reciever user id -> chat -> sender user id -> set data
    final recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(recieverChatContact.toMap());

    //user -> sender user id -> chat -> reciever user id -> set data
    final senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserId,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection(
      {required String recieverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String senderUserName,
      required String recieverUserName,
      required MessageEnum messageType}) async {
    //users -> senderId -> chats -> recieverId -> message -> set data
    final message = Message(
        recieverId: recieverUserId,
        senderId: auth.currentUser!.uid,
        text: text,
        messageType: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    //users -> recieverId  -> chats -> senderId -> message -> set data
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      final timeSent = DateTime.now();
      final recieverUserMap = await firestore
          .collection('users')
          .doc('txn0xLnwMHejZRznLnGKDfa5m3r2')
          .get();
      UserModel recieverUserData = UserModel.fromMap(recieverUserMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          senderUserData: senderUser,
          recieverUserData: recieverUserData,
          recieverUserId: recieverUserId,
          timeSent: timeSent,
          text: text);

      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          senderUserName: senderUser.name,
          recieverUserName: recieverUserData.name);
      print("message send repo provider");
    } catch (e) {
      print("error occured: ${e.toString()}");
    }
  }
}
