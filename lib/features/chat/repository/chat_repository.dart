import 'dart:io';

import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/provider/message_reply_provider.dart';
import 'package:chatapp/common/repository/common_firebase_storage_repository.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/group.dart' as model;

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

  Stream<List<model.Group>> getGroupChatContacts() {
    return firestore.collection('groups').snapshots().map((event) {
      List<model.Group> groups = [];
      for (var document in event.docs) {
        model.Group group = model.Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups; // Return the list of ChatContact objects.
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactSubcollection(
      {required UserModel senderUserData,
      required UserModel? recieverUserData,
      required String text,
      required DateTime timeSent,
      required String recieverUserId,
      required bool isGroupChat}) async {
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .update({'lastMessage': text, 'timeSent': DateTime.now()});
    } else {
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
          name: recieverUserData!.name,
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
  }

  void _saveMessageToMessageSubCollection(
      {required String recieverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String senderUserName,
      required String? recieverUserName,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required MessageEnum repliedMessageType,
      required bool isGroupChat}) async {
    //users -> senderId -> chats -> recieverId -> message -> set data
    final message = Message(
        recieverId: recieverUserId,
        senderId: auth.currentUser!.uid,
        text: text,
        messageType: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUserName
                : recieverUserName ?? '',
        repliedMessageType: repliedMessageType);

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
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
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        final recieverUserMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(recieverUserMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          senderUserData: senderUser,
          recieverUserData: recieverUserData,
          recieverUserId: recieverUserId,
          timeSent: timeSent,
          text: text,
          isGroupChat: isGroupChat);

      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          senderUserName: senderUser.name,
          recieverUserName: recieverUserData?.name,
          messageReply: messageReply,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum,
          isGroupChat: isGroupChat);
      print("message send repo provider");
    } catch (e) {
      print("error occured: ${e.toString()}");
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required ProviderRef ref,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              ref:
                  'chats/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file: file);
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var recieverUserDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(recieverUserDataMap.data()!);
      }

      String contactMsg = '';

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 image';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 video';
          break;
        case MessageEnum.audio:
          contactMsg = '🔉 audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactSubcollection(
          senderUserData: senderUserData,
          recieverUserData: recieverUserData,
          text: contactMsg,
          timeSent: timeSent,
          recieverUserId: recieverUserId,
          isGroupChat: isGroupChat);
      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          senderUserName: senderUserData.name,
          recieverUserName: recieverUserData?.name,
          messageType: messageEnum,
          messageReply: messageReply,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String senderId,
    String messageId,
  ) async {
    try {
      print("sender:${auth.currentUser!.uid},reciever: ${senderId}");
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      print("sender:${auth.currentUser!.uid},reciever: ${senderId}");
      await firestore
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
