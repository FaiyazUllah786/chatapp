import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/colors.dart';
import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayTextFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool _isAudioPlaying = false;
    AudioPlayer _audioPlayer = AudioPlayer();
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
      case MessageEnum.audio:
        return StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
                constraints: const BoxConstraints(minWidth: 100),
                onPressed: () async {
                  try {
                    if (_isAudioPlaying) {
                      await _audioPlayer.pause();
                      setState(() {
                        _isAudioPlaying = false;
                      });
                    } else {
                      await _audioPlayer.play(UrlSource(message));
                      setState(() {
                        _isAudioPlaying = true;
                      });
                    }
                  } on AudioPlayerException catch (e) {
                    showSnackBar(context: context, content: e.toString());
                  }
                },
                icon: Icon(_isAudioPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded));
          },
        );
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
