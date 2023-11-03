import 'dart:io';

import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/status/repository/status_repository.dart';
import 'package:chatapp/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({required this.statusRepository, required this.ref});

  Future<void> addStatus(File file, BuildContext context) async {
    // ref.watch(userDataAuthProvider).whenData((value) {
    //   print('in controller');
    //   print('${value!.name},${value.phoneNumber},${value.profilePic}');
    //   statusRepository.uploadStatus(
    //       userName: value!.name,
    //       phoneNumber: value.phoneNumber,
    //       profilePic: value.profilePic,
    //       statusImage: file,
    //       context: context);
    // });
    await statusRepository.uploadStatus(statusImage: file, context: context);
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }

  Stream<List<Status>> getStatusStream(BuildContext context) {
    return statusRepository.getStatusStream(context);
  }
}
