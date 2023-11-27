import 'package:chatapp/common/widgets/glassmorphism.dart';
import 'package:chatapp/features/status/screens/status_contact_screen.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/custom_loading_indicator.dart';
import '../controller/chat_controller.dart';
import '../../../models/chat_contact.dart';
import '../../../models/group.dart' as model;
import '../screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.blue,
            height: 100,
            child: StreamBuilder<List<model.Group>>(
              stream: ref.watch(chatControllerProvider).groupChatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadinIndicator(); // Display a loading indicator while data is loading.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final groupDataList = snapshot.data;

                  if (groupDataList!.isEmpty) {
                    return const Text('No chat contacts available.');
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    shrinkWrap: true,
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    itemBuilder: (context, index) {
                      var groupData = groupDataList[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'profilePic': groupData.groupPic,
                                  'isGroupChat': true,
                                });
                          },
                          child: GlassMorphism(
                            start: 0.2,
                            end: 0,
                            child: ListTile(
                              title: Text(
                                groupData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  groupData.lastMessage,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  groupData.groupPic,
                                ),
                                radius: 24,
                              ),
                              trailing: Text(
                                DateFormat.jm()
                                    .format(groupData.timeSent)
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.amber,
            height: 400,
            child: StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadinIndicator(); // Display a loading indicator while data is loading.
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final chatContacts = snapshot.data;

                  if (chatContacts!.isEmpty) {
                    return const Text('No chat contacts available.');
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    shrinkWrap: true,
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    itemBuilder: (context, index) {
                      var chatContactData = chatContacts[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                  'profilePic': chatContactData.profilePic,
                                  'isGroupChat': false,
                                });
                          },
                          child: GlassMorphism(
                            start: 0.2,
                            end: 0,
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
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      chatContactData.profilePic,
                                    ),
                                    radius: 24,
                                  ),
                                  StreamBuilder<List<Message>>(
                                      stream: ref
                                          .watch(chatControllerProvider)
                                          .chatStream(
                                              chatContactData.contactId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var messageList = snapshot.data!;
                                          var notSeenMessages =
                                              messageList.where(
                                            (element) {
                                              return (element.isSeen == false &&
                                                  element.recieverId !=
                                                      chatContactData
                                                          .contactId);
                                            },
                                          );
                                          if (notSeenMessages.isNotEmpty) {
                                            return Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.green,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      notSeenMessages.length >
                                                              99
                                                          ? '99+'
                                                          : notSeenMessages
                                                              .length
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )));
                                          }
                                        }
                                        return const SizedBox();
                                      }),
                                ],
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
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
