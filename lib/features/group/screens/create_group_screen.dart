import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/group/controller/group_controller.dart';
import 'package:chatapp/features/group/widgets/select_contacts_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _groupNameController = TextEditingController();
  File? image;
  void _pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _groupNameController.dispose();
  }

  void createGroup() {
    if (_groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context,
          _groupNameController.text.trim(),
          image!,
          ref.read(selectedGroupContacts));
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                (image == null)
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS__rdzgGVtykVfE-rpibK1pSf0TKL-r0lmrPpj0Y_NY_smuhAhQaCDnEjWSRPsiYzF1jw&usqp=CAU",
                        ),
                        radius: 100,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 100,
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      iconSize: 30,
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_a_photo_rounded)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                    hintText: 'Enter group name',
                    hintStyle: TextStyle(color: Colors.white60)),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //something is faulty here
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
        ),
      ),
    );
  }
}
