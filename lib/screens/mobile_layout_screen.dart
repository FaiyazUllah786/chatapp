import 'dart:io';

import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/auth/screens/account_info_screen.dart';
import 'package:chatapp/features/auth/screens/userInformation_screen.dart';
import 'package:chatapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:chatapp/features/status/screens/confirm_status_screen.dart';
import 'package:chatapp/features/status/screens/status_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/chat/widgets/contacts_list.dart';
import '../colors.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const routeName = "/mobile-layout";
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_changeFabICon);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_changeFabICon);
    tabController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      default:
        ref.read(authControllerProvider).setUserState(false);
    }
  }

  IconData _fabICon = Icons.comment;
  void _changeFabICon() {
    print(tabController.index);
    if (tabController.index == 0) {
      setState(() {
        _fabICon = Icons.comment;
      });
    } else if (tabController.index == 1) {
      setState(() {
        _fabICon = Icons.camera_alt;
      });
    } else {
      setState(() {
        _fabICon = Icons.add_call;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PopupMenuButton(
                color: backgroundColor,
                child: const Icon(Icons.more_vert_rounded),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: Text('Account'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountInfoScreen(),
                            )))
                  ];
                },
              ),
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactsList(),
            StatusContactScreen(),
            Text('Snow'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                    arguments: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: Icon(
            _fabICon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
