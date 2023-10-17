import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/error.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routeName = "/select-contact";
  const SelectContactScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedcontact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedcontact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) {
              return ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () {
                        print(contact.phones[0].normalizedNumber);
                      },
                      child: InkWell(
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
