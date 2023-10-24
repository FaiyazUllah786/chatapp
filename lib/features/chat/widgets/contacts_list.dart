import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/custom_loading_indicator.dart';
import '../controller/chat_controller.dart';
import '../../../models/chat_contact.dart';
import '../../../colors.dart';
import '../screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref.watch(chatControllerProvider).chatContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadinIndicator(); // Display a loading indicator while data is loading.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final chatContacts = snapshot.data;

          if (chatContacts!.isEmpty) {
            return Text('No chat contacts available.');
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            shrinkWrap: true,
            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
            itemBuilder: (context, index) {
              var chatContactData = chatContacts[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': chatContactData.name,
                            'uid': chatContactData.contactId
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          chatContactData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContactData.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactData.profilePic,
                          ),
                          radius: 24,
                        ),
                        trailing: Text(
                          DateFormat.jm()
                              .format(chatContactData.timeSent)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      },
    );
  }
}
