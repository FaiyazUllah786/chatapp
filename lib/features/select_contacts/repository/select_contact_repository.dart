import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(fireStore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore fireStore;
  SelectContactRepository({required this.fireStore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
        print("${contacts.length} inside repo");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(
      {required Contact selectedContact, required BuildContext context}) async {
    try {
      final userCollection = await fireStore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        final userData = UserModel.fromMap(document.data());
        print(selectedContact.phones[0].normalizedNumber);
        String selectedPhoneNumber = selectedContact.phones[0].normalizedNumber;
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          print("number found");
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: "This number does not exist on this app");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
