import 'dart:async';
import 'dart:io';

import 'package:chatapp/common/repository/common_firebase_storage_repository.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/status.dart';
import 'package:chatapp/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  Future<void> uploadStatus({
    // required String userName,
    // required String phoneNumber,
    // required String profilePic,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      String statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      var userDataMap = await firestore.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userDataMap.data()!);
      //uploading status to firebase storage
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              ref: '/status/$uid/$statusId', file: statusImage);
      //get list of contacts of your phone directory
      // List<Contact> contacts = [];
      // if (await FlutterContacts.requestPermission()) {
      //   contacts = await FlutterContacts.getContacts(withProperties: true);
      // }
      //adding user who can see your status(all the user who's number is present in your contacts)
      //implement this to user whom you chats
      List<String> uidWhoCanSee = [];
      // for (int i = 0; i < contacts.length; i++) {
      //   var userDataFirebase = await firestore
      //       .collection('users')
      //       .where('phoneNumber',
      //           isEqualTo: contacts[i].phones[0].normalizedNumber)
      //       .get();
      //   if (userDataFirebase.docs.isNotEmpty) {
      //     var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
      //     uidWhoCanSee.add(userData.uid);
      //   }
      // }
      var usersDataFirebase = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .get();
      for (int i = 0; i < usersDataFirebase.docs.length; i++) {
        // print(usersDataFirebase.docs[i].data());
        uidWhoCanSee.add(usersDataFirebase.docs[i].data()['contactId']);
        print(uidWhoCanSee[i]);
      }
      //to see status also on my phone
      uidWhoCanSee.add(auth.currentUser!.uid);

      //adding uploaded status image url to firestore database
      List<String> statusImageUrl = [];
      //updating status if it is already present
      var statusesSnapshot = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrl = status.photoUrl;
        statusImageUrl.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({'photoUrl': statusImageUrl});
        return;
      } else {
        //adding status first time
        statusImageUrl = [imageUrl];
      }

      //creating status model to upload it to firebase database
      print("in repository");
      print(
          '${userModel.name},${userModel.phoneNumber},${userModel.profilePic}');
      Status status = Status(
          uid: uid,
          userName: userModel.name,
          phoneNumber: userModel.phoneNumber,
          profilePic: userModel.profilePic,
          photoUrl: statusImageUrl,
          createdAt: DateTime.now(),
          statusId: statusId,
          whoCanSee: uidWhoCanSee);

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
      print(e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> status = [];
    try {
      var statusesSnapshot = await firestore
          .collection('status')
          .where('whoCanSee', arrayContains: auth.currentUser!.uid)
          .get();
      if (statusesSnapshot.docs.isNotEmpty) {
        for (var document in statusesSnapshot.docs) {
          var statusData = Status.fromMap(document.data());
          status.add(statusData);
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return status;
  }

  // Import the async library

  Stream<List<Status>> getStatusStream(BuildContext context) {
    // Create a StreamController to manage the stream
    StreamController<List<Status>> controller = StreamController();

    void updateStatusList() async {
      List<Status> status = [];
      try {
        var statusesSnapshot = await firestore
            .collection('status')
            .where('whoCanSee', arrayContains: auth.currentUser!.uid)
            .snapshots();

        statusesSnapshot.listen((querySnapshot) {
          status.clear();
          for (var document in querySnapshot.docs) {
            var statusData = Status.fromMap(document.data());
            status.add(statusData);
          }
          // Add the updated list of statuses to the stream
          controller.add(status);
        });
      } catch (e) {
        // Handle errors, such as showing a snackbar
        // You can replace this part with your error handling logic
        showSnackBar(context: context, content: e.toString());
      }
    }

    // Call the function to start listening for updates
    updateStatusList();

    // Return the stream from the StreamController
    return controller.stream;
  }
}
