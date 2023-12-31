import 'package:flutter/material.dart';

import '../../colors.dart';

class CustomLoadinIndicator extends StatelessWidget {
  const CustomLoadinIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: LinearProgressIndicator(
              color: tabColor,
            ),
          ),
          SizedBox(height: 20),
          Text("Please wait this can take few seconds!")
        ],
      )),
    );
  }
}
