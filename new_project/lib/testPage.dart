import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project/colors.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Widget buildTextFild() {
    try {
      return TextField(
        cursorColor: const Color(0xffA2C9FF),
        onChanged: (value) {
          setState(() {
            enableSendButton = value.isNotEmpty;
          });
        },
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          fillColor: secondary.withOpacity(0.1),
          filled: true,
          hintText: ' Message',
          hintStyle: TextStyle(color: const Color(0xffA8ADBD)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
    return Container();
  }

  bool enableSendButton = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                flex: !enableSendButton ? 1 : 0,
                child: !enableSendButton
                    ? InkWell(
                        child: Image.asset("images/photo_camera.png"),
                        onTap: () {
                          //   sendMediaFromCamera();
                        },
                      )
                    : Container()),
            Expanded(
                flex: !enableSendButton ? 1 : 0,
                child: !enableSendButton
                    ? IconButton(
                        icon: const Icon(Icons.image),
                        color: const Color(0xffA2C9FF),
                        onPressed: () {
                          //    messageFocusNode.unfocus();
                          //     sendMedia();
                        },
                      )
                    : Container()),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  height: size.height * 0.06,
                  child: buildTextFild(),
                ),
              ),
            ),
            Expanded(
                flex: enableSendButton ? 1 : 0,
                child: enableSendButton
                    ? InkWell(
                        onTap: () async {
                          // sendMessage(_msgCon.text);
                          // _msgCon.clear();
                          setState(() {
                            enableSendButton = false;
                          });
                        },
                        child: SvgPicture.asset("images/sendButton.svg"))
                    : Container())
          ],
        ),
      )),
    );
  }
}
