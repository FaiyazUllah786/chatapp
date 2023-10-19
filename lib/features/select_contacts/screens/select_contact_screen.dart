import 'package:chatapp/colors.dart';

import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/error.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chatapp/features/select_contacts/repository/select_contact_repository.dart';
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

  bool _openSearchBar = false;
  List<Contact> _searchContactList = [];

//  List<Contact> _searchContact({required String searchText})async{
//     List<Contact> contactList = await ref.read(selectContactControllerProvider).getContacts();
//     final searchContactName = searchText.toLowerCase();
//                         return contactList.where((element) => element.name
//                             .toString()
//                             .toLowerCase()
//                             .contains(searchContactName))
//                         .toList();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _openSearchBar
            ? TextField(style: TextStyle(fontSize: 20),
              autofocus: true,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search contact name...",
                    hintStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                onChanged: (value) {
                  // _searchContactList=_searchContact(searchText: value);
                  setState(() {
                    
                  });
                 
                },
              )
            : const Text("Select Contacts"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _openSearchBar = !_openSearchBar;
                  print(_openSearchBar);
                });
              },
              icon: _openSearchBar ? Icon(Icons.close) : Icon(Icons.search)),
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
                    onTap: () {},
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
              print(contactList.length);
              return ListView.builder(
                  itemCount: _openSearchBar
                      ? _searchContactList.length
                      : contactList.length,
                  itemBuilder: (context, index) {
                    var contact;
                    if (_openSearchBar) {
                      contact = _searchContactList[index];
                    } else {
                      contact = contactList[index];
                    }

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
