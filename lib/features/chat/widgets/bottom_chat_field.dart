import 'dart:io';

import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({super.key, required this.recieverUserId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool _isShowSendButton = false;
  final _messageController = TextEditingController();

  void _sendTextMessage() async {
    if (_isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);
      print('message sent!! ${widget.recieverUserId}');
    }
    setState(() {
      _messageController.clear();
    });
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.recieverUserId, messageEnum);
  }

  void _selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _isShowSendButton = true;
                });
              } else {
                setState(() {
                  _isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions,
                  color: Colors.grey,
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Transform.rotate(
                          angle: 150.0,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.attach_file_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _selectImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
          child: InkWell(
            onTap: _sendTextMessage,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 25,
              child: _isShowSendButton
                  ? const Icon(Icons.send)
                  : const Icon(Icons.mic),
            ),
          ),
        )
      ],
    );
  }
}
