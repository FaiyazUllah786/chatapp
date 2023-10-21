import 'package:flutter/material.dart';

import '../../../colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool _isShowSendButton = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
                      onPressed: () {},
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
          child: CircleAvatar(
            backgroundColor: Color(0xFF128C7E),
            radius: 25,
            child: _isShowSendButton
                ? const Icon(Icons.send)
                : const Icon(Icons.mic),
          ),
        )
      ],
    );
  }
}
