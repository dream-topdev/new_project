import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_project/chat_screen.dart';
import 'package:new_project/colors.dart';
import 'package:new_project/data/Api.dart';

// ignore: must_be_immutable
class StartChat extends StatefulWidget {
  const StartChat({Key? key}) : super(key: key);

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  List<String> images = [
    "https://th.bing.com/th/id/OIP.LXkv_HqpRzSoTE9Y76ZVHwHaE7?rs=1&pid=ImgDetMain",
    "https://rayusradiology.com/wp-content/uploads/2018/10/colorSharad_Chopra_256x.jpg",
    "https://www.wpi.edu/sites/default/files/faculty-image/meltabakh.jpg",
    "https://th.bing.com/th/id/OIP.BfVYFNt_b_InY0cSc7iurQHaI4?w=500&h=600&rs=1&pid=ImgDetMain"
  ];
  List<String> names = ["Jhon Doe", "Matrine Doe", "Mary Doe", "James"];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? searchQuery;
  List<Users> list = [];
  DocumentSnapshot? currentUserName;
  final ios = Platform.isIOS;
  void getCurrentUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? username = user.email;
      currentUserName = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (username != null && username.isNotEmpty) {
        print("Username: ${currentUserName!['username']}");
      } else {
        print("No username set for the current user.");
      }
    } else {
      print("No user is currently logged in.");
    }
  }

  @override
  void initState() {
    getCurrentUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondary.withOpacity(0.03),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          height: size.height * 0.9,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width * 0.6,
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: secondary.withOpacity(0.1),
                                spreadRadius: 10,
                                offset: const Offset(-2, 50),
                                blurStyle: BlurStyle.normal,
                                blurRadius: 500)
                          ],
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.6,
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: secondary.withOpacity(0.1),
                                spreadRadius: 10,
                                offset: const Offset(-1, 20),
                                blurStyle: BlurStyle.normal,
                                blurRadius: 500)
                          ],
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                // ignore: sort_child_properties_last

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: sort_child_properties_last

                children: [
                  Container(
                    color: Colors.black,
                    width: size.width,
                    height: size.height * 0.11,
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                Icon(
                                  ios ? Icons.arrow_back_ios : Icons.arrow_back,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                const Text(
                                  "Back",
                                  style:
                                      TextStyle(fontSize: 18, color: textColor),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.16,
                          ),
                          const Text(
                            "Start Chat",
                            style: TextStyle(fontSize: 22, color: textColor),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Center(
                    child: Container(
                      //padding: EdgeInsets.all(2),
                      height: size.height * 0.1,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: secondary.withOpacity(0.2))
                          // Border(
                          //     right: BorderSide(color: secondary),
                          //     top: BorderSide(color: secondary),
                          //     bottom:
                          //         BorderSide(color: secondary.withOpacity(0.4)),
                          //     left:
                          //         BorderSide(color: secondary.withOpacity(0.4)))
                          ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: size.width * 0.04),
                            const Text(
                              "with:  ",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            SizedBox(
                              height: size.height * 0.07,
                              width: size.width * 0.7,
                              child: TextField(
                                cursorColor: secondary,
                                style: const TextStyle(color: textColor),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  hintText: '  Search',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Set border radius
                                  ),
                                  // suffixIcon: IconButton(
                                  //   icon: const Icon(
                                  //     Icons.mic,
                                  //     color: Color(0xff989898),
                                  //   ),
                                  //   onPressed: () {
                                  //     // Handle microphone icon press
                                  //   },
                                  // ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Suggestions",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Expanded(
                      flex: 3,
                      child: StreamBuilder(
                        stream: searchQuery == null
                            ? _firestore
                                .collection('user')
                                .where("username",
                                    isNotEqualTo: currentUserName)
                                .snapshots()
                            : _firestore
                                .collection('user')
                                .where('username', isEqualTo: searchQuery)
                                .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              list = data
                                      ?.map((e) => Users.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (list.isNotEmpty) {
                                return ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  itemCount: list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Research(
                                      users: list[index],
                                      receiverId: snapshot.data!.docs[index]
                                          .data()['uid'],
                                    );
                                  },
                                );
                              } else {
                                return Container();
                              }
                          }
                        },
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Research extends StatefulWidget {
  const Research({Key? key, required this.users, this.receiverId})
      : super(key: key);
  final Users users;
  final String? receiverId;

  @override
  State<Research> createState() => _ResearchState();
}

class _ResearchState extends State<Research> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 0.3, color: secondary.withOpacity(0.15))),
        // Border.all(
        //     width: 0.3,
        //     color: secondary.withOpacity(0.15))
      ),
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiverId: widget.receiverId!,
                          full_name: widget.users.full_name,
                          avatar: widget.users.avatar,
                        )));
            //  print(widget.receiverId);
          },
          trailing: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                  width: size.width * 0.1,
                  height: size.height * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child:
                      // Image.asset(
                      //   "images/message.png",
                      //   height: size.height * 0.04,
                      //   width: size.width * 0.04,
                      // )),
                      SvgPicture.asset(
                    "images/message.svg",
                    height: size.height * 0.026,
                    width: size.width * 0.026,
                    //fit: BoxFit.fill,
                    color: secondary,
                  )),
            ),
          ),
          leading:
              //  CircleAvatar(
              //   radius: 25,
              //   backgroundImage:
              //    NetworkImage(
              //    snapshot.data.docs[i].data()["avatar"],
              //   ),
              // ),
              Container(
            // height: size.height * 0.09,
            // width: size.width * 0.07,
            child: ClipOval(
                child: Image.network(
                    height: size.height * 0.07,
                    width: size.width * 0.07,
                    fit: BoxFit.fill,
                    '${widget.users.avatar}')),
          ),
          title: Text(
            widget.users.full_name,
            style: const TextStyle(fontSize: 21, color: textColor),
          ),
          subtitle:
              const Text(" VIP Coaches", style: TextStyle(color: greenColor))),
    );
  }
}
