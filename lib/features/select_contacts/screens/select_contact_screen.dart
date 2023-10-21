import 'package:chatapp/colors.dart';

import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/error.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chatapp/features/select_contacts/repository/select_contact_repository.dart';
import 'package:chatapp/widgets/contacts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  static const routeName = "/select-contact";
  const SelectContactScreen({super.key});

  @override
  ConsumerState<SelectContactScreen> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen> {
  void selectContact(
      WidgetRef ref, Contact selectedcontact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedcontact, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(
              onPressed: () {
              },
              icon: Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      FlutterContacts.openExternalInsert();
                    },
                    child: const Row(
                      children: [
                        PopupMenuItem(child: Icon(Icons.add)),
                        Text('add contact')
                      ],
                    )),
                PopupMenuItem(
                    onTap: () async{
                      
                    },
                    child: const Row(
                      children: [
                        PopupMenuItem(child: Icon(Icons.refresh)),
                        Text('Refresh')
                      ],
                    ))
              ];
            },
            color: backgroundColor,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: whiteColor,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) {
              print("${contactList.length} inside body");
              return ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                     final contact = contactList[index];
                    return InkWell(
                      onTap: () => selectContact(ref, contact, context),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(contact.displayName),
                          leading: contact.photo == null
                              ? const CircleAvatar(
                                  backgroundColor: whiteColor,
                                  child: Icon(
                                    Icons.person,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(contact.photo!),
                                  radius: 30,
                                ),
                        ),
                      ),
                    );
                  });
            },
            error: ((error, stackTrace) =>
                ErrorScreen(error: error.toString())),
            loading: () => const CustomLoadinIndicator(),
          ),
     
    );
  }
}
