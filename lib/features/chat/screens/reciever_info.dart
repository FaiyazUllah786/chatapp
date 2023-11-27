import 'package:chatapp/models/user_model.dart';
import 'package:flutter/material.dart';

class RecieverInfo extends StatelessWidget {
  static const routeName = '/reciever-info';
  final UserModel reciever;
  const RecieverInfo({super.key, required this.reciever});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Image.network(
                      reciever.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                  pinned: true,
                  title: Text(
                    reciever.name,
                  ),
                ),
              ],
          body: const Text('')),
    );
  }
}
