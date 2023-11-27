import 'dart:io';

import 'package:chatapp/common/repository/common_firebase_storage_repository.dart';
import 'package:chatapp/features/auth/screens/account_info_screen.dart';
import 'package:chatapp/features/auth/screens/userInformation_screen.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/mobile_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../screens/otp_screen.dart';

//creating provider globally to access it all across the project
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            showSnackBar(context: context, content: e.message!);
            throw Exception(e.message);
          },
          codeSent: (String verificationId, int? resendCode) async {
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<void> verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<void> saveUserDataToFirestore(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      final uid = auth.currentUser!.uid;
      String photoUrl =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS__rdzgGVtykVfE-rpibK1pSf0TKL-r0lmrPpj0Y_NY_smuhAhQaCDnEjWSRPsiYzF1jw&usqp=CAU";
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(ref: "profilePic/$uid", file: profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          lastSeen: DateTime.now(),
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushNamedAndRemoveUntil(
        context,
        MobileLayoutScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> updateUserProfilePicToFirestore(
      {required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      final uid = auth.currentUser!.uid;
      if (profilePic != null) {
        String photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(ref: "profilePic/$uid", file: profilePic);
        await firestore
            .collection('users')
            .doc(uid)
            .update({'profilePic': photoUrl});
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> updateUserNameToFirestore(
      {required String name,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      final uid = auth.currentUser!.uid;
      if (name.isNotEmpty) {
        await firestore.collection('users').doc(uid).update({'name': name});
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    final userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel?> getCurrentUserDataStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((event) {
      return UserModel.fromMap(event.data()!);
    });
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline, 'lastSeen': DateTime.now()});
  }
}
