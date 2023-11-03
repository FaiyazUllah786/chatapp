import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider((ref) {
  return CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance);
});

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storeFileToFirebase(
      {required String ref, required File file}) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Future<String> uploadFile({required String ref, required File file}) async {
  //   Reference storageReference = firebaseStorage.ref().child(ref);

  //   UploadTask uploadTask = storageReference.putFile(file);

  //   uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //     double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
  //     print('Upload progress: $progress');

  //     // Update your progress indicator here
  //     // Example: _updateProgressIndicator(progress);
  //   });

  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   print('File Uploaded');
  //   return downloadUrl;
  // }

  // void downloadFile( {required String ref, required File file}) async {
  // Reference storageReference =firebaseStorage.ref().child(ref);

  // TaskSnapshot taskSnapshot = await storageReference.getData();

  // taskSnapshot.ref.getData().listen((List<int> data) {
  //   double progress = (data.length / taskSnapshot.totalBytes);
  //   print('Download progress: $progress');

  //   // Update your progress indicator here
  //   // Example: _updateProgressIndicator(progress);
  // });

  // }
}
