import 'package:chatapp/colors.dart';
import 'package:chatapp/common/utils/utils.dart';

import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';
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

  List<Contact> allContacts = []; // Store all contacts
  String query = ''; // Store the search query

  List<Contact> getFilteredContacts() {
    return allContacts.where((contact) {
      final displayName = contact.displayName.toLowerCase();
      return displayName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  bool _isLoading = false;
  bool _isSearchOpen = false;
  Future<void> loadContacts() async {
    setState(() {
      _isLoading = true;
    });
    final contacts =
        await ref.read(selectContactControllerProvider).getChatContacts();
    setState(() {
      allContacts = contacts;
      query = '';
      _isSearchOpen = false;
      _isLoading = false;
    });
  }

  final searchController = TextEditingController();
  final searchFocus = FocusNode();
  void _handleTap() {
    if (searchFocus.hasFocus) {
      searchFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = getFilteredContacts();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearchOpen = !_isSearchOpen;
                });
                _isSearchOpen
                    ? searchFocus.requestFocus()
                    : searchFocus.unfocus();
              },
              icon: Icon(_isSearchOpen ? Icons.close : Icons.search)),
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
                    onTap: () async {
                      await loadContacts();

                      showSnackBar(
                          context: context,
                          content: 'your contact list has been updated');
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
      body: _isLoading
          ? const CustomLoadinIndicator()
          : Column(
              children: [
                if (_isSearchOpen)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: blackColor.withOpacity(0.2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                          },
                          focusNode: searchFocus,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search contact name',
                            hintStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
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
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
