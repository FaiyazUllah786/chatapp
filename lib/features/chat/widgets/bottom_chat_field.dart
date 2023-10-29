import 'dart:io';

import 'package:chatapp/common/message_enum.dart';
import 'package:chatapp/common/provider/message_reply_provider.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:chatapp/features/chat/widgets/message_reply_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _isRecorderInit = false;
  bool _isRecording = false;
  final _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission not allowed.');
    }
    await _soundRecorder!.openRecorder();
    _isRecorderInit = true;
  }

  void _sendTextMessage() async {
    if (_isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);
      print('message sent!! ${widget.recieverUserId}');
      setState(() {
        _messageController.clear();
        _isShowSendButton = false;
      });
    } else {
      //mic button is showing

      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!_isRecorderInit) return;
      if (_isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  void _selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void _selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.recieverUserId, messageEnum);
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    _isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                                  onPressed: _selectVideo,
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
                  padding:
                      const EdgeInsets.only(bottom: 5.0, left: 1, right: 1),
                  child: ElevatedButton(
                      onPressed: _sendTextMessage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: tabColor,
                        foregroundColor: whiteColor,
                        minimumSize: const Size.fromRadius(23),
                        alignment: Alignment.center,
                      ),
                      child: _isShowSendButton
                          ? const Icon(
                              Icons.send,
                              color: whiteColor,
                            )
                          : Icon(
                              _isRecording ? Icons.close : Icons.mic,
                              color: whiteColor,
                            ))
                  // ),
                  )
            ],
          ),
        ),
      ],
    );
  }
}
