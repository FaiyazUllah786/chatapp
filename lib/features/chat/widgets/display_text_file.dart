import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/colors.dart';
import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayTextFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    print(message);
    switch (type) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: const CircularProgressIndicator(
              color: tabColor,
            ),
          ),
        );
      case MessageEnum.video:
        return VideoPlayerItem(videoUrl: message);
      default:
        return Placeholder();
    }
    // return type == MessageEnum.text
    //     ? Text(
    //         message,
    //         style: const TextStyle(
    //           fontSize: 16,
    //         ),
    //       )
    //     : CachedNetworkImage(
    //         imageUrl: message,
    //         placeholder: (context, url) => Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: const CircularProgressIndicator(
    //             color: tabColor,
    //           ),
    //         ),
    //       );
  }
}
