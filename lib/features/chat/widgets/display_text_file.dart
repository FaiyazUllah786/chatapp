import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/common/message_enum.dart';
import 'package:flutter/material.dart';

class DisplayTextFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : CachedNetworkImage(imageUrl: message);
  }
}
