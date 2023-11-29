import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/call/screens/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/call.dart';
import '../../../models/group.dart';

final callRepositoryProvider = Provider((ref) => CallRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class CallRepository {
  FirebaseFirestore firestore;
  FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  void makeCall(
      {required BuildContext context,
      required Call senderCallData,
      required Call recieverCallData}) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(senderCallData.recieverId)
          .set(recieverCallData.toMap());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
                channelId: senderCallData.callId,
                call: senderCallData,
                isGroupChat: false),
          ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
      {required BuildContext context,
      required String callerId,
      required String recieverId}) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      await firestore.collection('calls').doc(recieverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
      {required BuildContext context,
      required Call senderCallData,
      required Call recieverCallData}) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.recieverId)
          .get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        if (!id.contains(senderCallData.callerId)) {
          await firestore
              .collection('calls')
              .doc(id)
              .set(recieverCallData.toMap());
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
                channelId: senderCallData.callId,
                call: senderCallData,
                isGroupChat: true),
          ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
      {required BuildContext context,
      required String callerId,
      required String recieverId}) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(recieverId).get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        if (!id.contains(callerId)) {
          await firestore.collection('calls').doc(id).delete();
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();
}
