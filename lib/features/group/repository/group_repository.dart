import 'dart:io';

import 'package:chatapp/common/repository/common_firebase_storage_repository.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/group.dart' as model;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedGroupContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedGroupContacts.length; i++) {
        var userCollections = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: selectedGroupContacts[i].phones[0].normalizedNumber)
            .get();
        if (userCollections.docs.isNotEmpty && userCollections.docs[0].exists) {
          uids.add(userCollections.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(ref: 'group/$groupId', file: profilePic);
      model.Group group = model.Group(
          senderId: auth.currentUser!.uid,
          groupId: groupId,
          name: name,
          lastMessage: '',
          timeSent: DateTime.now(),
          groupPic: profileUrl,
          membersUid: [auth.currentUser!.uid, ...uids]);

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
