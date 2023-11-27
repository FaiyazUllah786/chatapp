import 'package:chatapp/common/widgets/custom_loading_indicator.dart';
import 'package:chatapp/common/widgets/error.dart';
import 'package:chatapp/features/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactIndex = [];

  void selectContacts(int index, Contact contact) {
    try {
      if (selectedContactIndex.contains(index)) {
        selectedContactIndex.removeAt(index);
      } else {
        selectedContactIndex.add(index);
      }
      setState(() {});
      ref
          .read(selectedGroupContacts.notifier)
          .update((state) => [...state, contact]);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) {
          return Expanded(
              child: ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContacts(index, contact),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(contact.displayName),
                    leading: selectedContactIndex.contains(index)
                        ? IconButton(
                            onPressed: () {}, icon: const Icon(Icons.done))
                        : null,
                  ),
                ),
              );
            },
          ));
        },
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const Expanded(child: CustomLoadinIndicator()));
  }
}
