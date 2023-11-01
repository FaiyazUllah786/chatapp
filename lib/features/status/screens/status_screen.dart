import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

import '../../../models/status.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({super.key, required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItem();
  }

  void initStoryPageItem() {
    storyItems.cast();
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: storyController));
      print(widget.status.photoUrl.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const CircularProgressIndicator()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onComplete: () => Navigator.pop(context),
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
