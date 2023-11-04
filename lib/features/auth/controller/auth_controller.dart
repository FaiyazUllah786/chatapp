import 'dart:io';

import 'package:chatapp/features/auth/repository/auth_repository.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.authRepository, required this.ref});

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    await authRepository.signInWithPhone(context, phoneNumber);
  }

  Future<void> verifyOtp(
      BuildContext context, String verificationId, String userOTP) async {
    await authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  Future<void> saveUserDataToFirestore(
      {required BuildContext context,
      required String name,
      File? profilePic}) async {
    await authRepository.saveUserDataToFirestore(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Future<void> updateUserProfilePicToFirestore(
      {required BuildContext context, required File? profilePic}) async {
    await authRepository.updateUserProfilePicToFirestore(
        profilePic: profilePic, ref: ref, context: context);
  }

  Future<void> updateUserNameToFirestore(
      {required BuildContext context, required String name}) async {
    await authRepository.updateUserNameToFirestore(
        name: name, ref: ref, context: context);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel?> getCurrentUserData() {
    return authRepository.getCurrentUserDataStream();
  }

  Stream<UserModel> getUserDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
