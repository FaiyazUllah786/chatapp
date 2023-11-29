import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/call/repository/call_repository.dart';
import 'package:chatapp/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(callRepository: callRepository, ref: ref);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  CallController({
    required this.callRepository,
    required this.ref,
  });

  void makeCall(
      {required BuildContext context,
      required String recieverName,
      required String recieverId,
      required String recieverPic,
      required bool isGroupChat}) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
          callerId: callRepository.auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          callId: callId,
          hasDialed: true,
          timeCall: DateTime.now());
      Call recieverCallData = Call(
          callerId: callRepository.auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          callId: callId,
          hasDialed: false,
          timeCall: DateTime.now());
      if (isGroupChat) {
        callRepository.makeGroupCall(
            context: context,
            senderCallData: senderCallData,
            recieverCallData: recieverCallData);
      } else {
        callRepository.makeCall(
            context: context,
            senderCallData: senderCallData,
            recieverCallData: recieverCallData);
      }
    });
  }

  void endCall(
      {required String callerId,
      required String recieverId,
      required BuildContext context,
      required bool isGroupChat}) {
    if (isGroupChat) {
      callRepository.endGroupCall(
          context: context, callerId: callerId, recieverId: recieverId);
    } else {
      callRepository.endCall(
          context: context, callerId: callerId, recieverId: recieverId);
    }
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
}
