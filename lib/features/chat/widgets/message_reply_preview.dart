import 'package:chatapp/colors.dart';
import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/provider/message_reply_provider.dart';
import 'package:chatapp/features/chat/widgets/display_text_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 10, color: mobileChatBoxColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'You' : 'Opposite',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: tabColor),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(messageReply.messageEnum == MessageEnum.text
              ? messageReply.message
              : messageReply.messageEnum == MessageEnum.audio
                  ? '🔉 audio'
                  : messageReply.messageEnum == MessageEnum.video
                      ? '🎥 video'
                      : '📷 image')
        ],
      ),
    );
  }
}
