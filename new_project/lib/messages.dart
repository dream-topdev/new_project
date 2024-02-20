import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/Start_chat.dart';
import 'package:new_project/chat_screen.dart';
import 'package:new_project/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_project/data/Api.dart';
import 'package:new_project/login_page.dart';
import 'package:new_project/main.dart';

// ignore: must_be_immutable
class Messages extends StatefulWidget {
  Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> images = [
    "https://th.bing.com/th/id/OIP.LXkv_HqpRzSoTE9Y76ZVHwHaE7?rs=1&pid=ImgDetMain",
    "https://rayusradiology.com/wp-content/uploads/2018/10/colorSharad_Chopra_256x.jpg",
    "https://www.wpi.edu/sites/default/files/faculty-image/meltabakh.jpg",
    "https://th.bing.com/th/id/OIP.BfVYFNt_b_InY0cSc7iurQHaI4?w=500&h=600&rs=1&pid=ImgDetMain"
  ];
  List<String> names = ["Jhon Doe", "Matrine Doe", "Mary Doe", "James"];
  List<String> lastMsg = [
    "that's awesome",
    "done, will meet tommorow",
    "i'm fine",
    "i'm going now"
  ];

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // CollectionReference userChat =
  //     FirebaseFirestore.instance.collection('userChat');
  List<UsersChat> list = [];
  int _currentIndex = 2;
  String? searchQuery;

  int totalUnreadMessages = 0;

  final ios = Platform.isIOS;
  Future<void> getTotalUnreadMessages() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .get();

    for (var doc in querySnapshot.docs) {
      setState(() {
        totalUnreadMessages += (doc.data()['unread_message'] ?? 0) as int;
      });
    }
  }

  // للظهور ارقام المرسلين
  @override
  void initState() {
    super.initState();
    // userChat
    //     .where('recipient', isEqualTo: _auth.currentUser!.email)
    //     .snapshots()
    //     .listen((snapshot) {
    //   setState(() {
    //     unreadMessagesCount = snapshot.docs.length;
    //   });
    // });
    getTotalUnreadMessages();
  }

  Future<void> _signOut() async {
    try {
      // Sign out from Firebase email authentication
      await _auth.signOut();

      // Sign out from Google Sign-In
      await _googleSignIn.signOut();
      await sharedPreferences!.setBool("remember", false);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
          (route) => false);

      print('User signed out');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // endDrawer: Drawer(
      //   backgroundColor: praimry,
      //   child: FutureBuilder(
      //     future: FirebaseFirestore.instance
      //         .collection("user")
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .get(),
      //     builder: (context, AsyncSnapshot snapshot) {
      //       if (snapshot.hasData) {
      //         return ListView(
      //           padding: EdgeInsets.zero,
      //           children: [
      //             Column(
      //               children: [
      //                 SizedBox(
      //                   height: size.height * 0.02,
      //                 ),
      //                 ListTile(
      //                   leading: Container(
      //                     // height: size.height * 0.09,
      //                     // width: size.width * 0.07,
      //                     child: ClipOval(
      //                         child: SvgPicture.network(
      //                             height: size.height * 0.06,
      //                             width: size.width * 0.02,
      //                             '${snapshot.data!['avatar']}')),
      //                   ),
      //                   title: Row(
      //                     children: [
      //                       Text(
      //                         "${snapshot.data['username']}",
      //                         style: TextStyle(color: textColor, fontSize: 16),
      //                       ),
      //                       Image.asset(
      //                         "images/down-arrow.png",
      //                         height: size.height * 0.024,
      //                         width: size.width * 0.039,
      //                         fit: BoxFit.fill,
      //                         color: dropDownColor,
      //                       )
      //                     ],
      //                   ),
      //                   trailing: SvgPicture.asset(
      //                     "images/Vector4.svg",
      //                     height: 18,
      //                     width: 18,
      //                   ),
      //                 ),
      //                 Divider(
      //                   thickness: 0.1,
      //                 )
      //               ],
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               leading: SvgPicture.asset("images/chatwithpoint.svg"),
      //               title: Text(
      //                 "Chat",
      //                 style: TextStyle(color: textColor, fontSize: 16),
      //               ),
      //               trailing: Container(
      //                 alignment: Alignment.center,
      //                 height: size.height * 0.07,
      //                 width: size.width * 0.07,
      //                 decoration: BoxDecoration(
      //                     border: Border.all(color: greenColor),
      //                     shape: BoxShape.circle,
      //                     color: Colors.transparent),
      //                 child: Text("1",
      //                     style: GoogleFonts.poppins(
      //                         color: textColor, fontSize: 16)),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               leading: SvgPicture.asset("images/Vector1.svg"),
      //               title: Text(
      //                 "Search",
      //                 style: TextStyle(color: textColor, fontSize: 16),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               leading: SvgPicture.asset(
      //                 "images/Vector2.svg",
      //               ),
      //               title: Text(
      //                 "Coaches",
      //                 style: TextStyle(color: textColor, fontSize: 16),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               leading: SvgPicture.asset("images/Vector3.svg"),
      //               title: Text(
      //                 "Profile",
      //                 style: TextStyle(color: textColor, fontSize: 16),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               leading: SvgPicture.asset("images/Vector4.svg"),
      //               title: Text(
      //                 "Settings",
      //                 style: TextStyle(color: textColor, fontSize: 16),
      //               ),
      //             ),
      //             Divider(
      //               thickness: 0.1,
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             ListTile(
      //               onTap: () async {
      //                 await _signOut();
      //               },
      //               leading: Icon(
      //                 Icons.logout,
      //                 color: Colors.red,
      //               ),
      //               title: Text(
      //                 "Logout",
      //                 style: TextStyle(color: Colors.red, fontSize: 16),
      //               ),
      //             ),
      //           ],
      //         );
      //       }
      //       return Center();
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => StartChat()));
          },
          backgroundColor: Colors.greenAccent,
          child:
              //  Image.asset(
              //   "images/message.png",
              // height: size.height * 0.04,
              // width: size.width * 0.08,
              // fit: BoxFit.fill,
              // color: praimry,
              // ),
              SvgPicture.asset(
            "images/message.svg",
            height: size.height * 0.035,
            width: size.width * 0.075,
            fit: BoxFit.fill,
            color: praimry,
          )),
      backgroundColor: secondary.withOpacity(0.02),
      // bottomNavigationBar: Container(
      //   color: praimry.withOpacity(0.2),
      //   alignment: Alignment.topCenter,
      //   height: size.height * 0.13,
      //   child: ClipRect(
      //     child: BottomNavigationBar(
      //       iconSize: 30,
      //       elevation: 0,
      //       type: BottomNavigationBarType.fixed,
      //       backgroundColor: praimry.withOpacity(0.2),
      //       currentIndex: 2,
      //       onTap: (index) {
      //         setState(() {
      //           _currentIndex = index;
      //           print(_currentIndex);
      //         });
      //       },
      //       items: [
      //         const BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.house_outlined,
      //             size: 24,
      //           ),
      //           label: 'Home',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: SvgPicture.asset(
      //             "images/plans.svg",
      //             height: size.height * 0.024,
      //             fit: BoxFit.fill,
      //             width: size.width * 0.02,
      //           ),
      //           label: 'Plans',
      //         ),
      //         BottomNavigationBarItem(
      //           icon:
      //               // Icon(
      //               //   Icons.mail_rounded,
      //               // ),
      //               SvgPicture.asset(
      //             "images/message.svg",
      //             height: size.height * 0.024,
      //             fit: BoxFit.fill,
      //             width: size.width * 0.02,
      //             color: secondary,
      //           ),
      //           label: 'Inbox',
      //         ),
      //         BottomNavigationBarItem(
      //           icon:
      //               // Icon(
      //               //   Icons.person,
      //               //   color: Colors.grey,
      //               // ),
      //               SvgPicture.asset(
      //             "images/person.svg",
      //             height: size.height * 0.02,
      //             fit: BoxFit.fill,
      //             width: size.width * 0.02,
      //           ),
      //           label: 'Profile',
      //         ),
      //       ],
      //       unselectedItemColor: Colors.grey,
      //       selectedItemColor: secondary,
      //     ),
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Container(
          height: size.height * 9,
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.6,
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: secondary.withOpacity(0.17),
                              spreadRadius: 10,
                              offset: const Offset(50, 90),
                              blurStyle: BlurStyle.normal,
                              blurRadius: 60)
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
                      width: size.width * 0.4,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: secondary.withOpacity(0.1),
                              spreadRadius: 10,
                              offset: const Offset(-1, 90),
                              blurStyle: BlurStyle.normal,
                              blurRadius: 60)
                        ],
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black,
                  width: size.width,
                  height: size.height * 0.13,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Image.asset(
                        //   "images/easyunilogo1.png",
                        //   height: 38.5,
                        //   width: 140,
                        //   fit: BoxFit.fill,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            "images/easyunilogo2.svg",
                            height: 38.5,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7, right: 8),
                          child: Text(
                            "Inbox",
                            style: GoogleFonts.poppins(
                                fontSize: 18.5, color: textColor),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 8),
                        //   child: InkWell(
                        //     onTap: () =>
                        //         _scaffoldKey.currentState?.openEndDrawer(),
                        //     child: SvgPicture.asset(
                        //       "images/jam_menu.svg",
                        //       // height: size.height * 0.07,
                        //       // width: size.width * 0.1,
                        //     ),
                        //   ),
                        // )
                      ]),
                ),
                Container(
                  height: size.height * 0.28,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.9,
                        child: TextField(
                          cursorColor: secondary,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          style: const TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.grey.withOpacity(0.1),
                            filled: true,
                            hintText: '   Search',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            // suffixIcon: IconButton(
                            //   icon: const Icon(
                            //     Icons.mic,
                            //     color: Colors.grey,
                            //   ),
                            //   onPressed: () {
                            //     // Handle microphone icon press
                            //   },
                            // ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("user")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("messages")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.length < 1) {
                                return Container();
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) => Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                            height: size.height * 0.1,
                                            width: size.width * 0.2,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 8),
                                            child: ClipOval(
                                              child: Image.network(
                                                  height: size.height * 0.1,
                                                  width: size.width * 0.2,
                                                  fit: BoxFit.fill,
                                                  "${snapshot.data!.docs[i].data()['avatar']}"),
                                            )
                                            //  CircleAvatar(
                                            //   backgroundImage:
                                            //   NetworkImage(
                                            //     "${snapshot.data!.docs[i].data()['avatar']}",
                                            //   ),
                                            //   radius: 35,
                                            // ),
                                            ),
                                        Positioned(
                                          top: 18,
                                          right: 10,
                                          child: Container(
                                            width: size.width * 0.08,
                                            height: size.height * 0.02,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: secondary,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                itemCount:
                                    // 4
                                    snapshot.data!.docs.length,
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: secondary,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: size.height * 0.09,
                  width: size.width,
                  color: secondary.withOpacity(0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Messages",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      Text(
                        "Unread ( $totalUnreadMessages )",
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xffC6C5D1)),
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: StreamBuilder(
                        stream: searchQuery == null
                            ? FirebaseFirestore.instance
                                .collection("user")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("messages")
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection("user")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("messages")
                                .where("username", isEqualTo: searchQuery)
                                .snapshots(),
                        builder: (context, snapshot) {
                          //  switch (snapshot.connectionState) {
                          // case ConnectionState.waiting:
                          // case ConnectionState.none:
                          // case ConnectionState.active:
                          // case ConnectionState.done:
                          //   final data = snapshot.data?.docs;
                          // list = data
                          //         ?.map((e) => UsersChat.fromJson(e.data()))
                          //         .toList() ??
                          //     [];
                          if (snapshot.hasData) {
                            // list.sort((a, b) => b.time.compareTo(a.time));
                            return InkWell(
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var friendId =
                                      snapshot.data!.docs[index].data()['uid'];
                                  var friendAvatar = snapshot.data!.docs[index]
                                      .data()['avatar'];
                                  // var friendLastMessage = snapshot
                                  //     .data!.docs[index]
                                  //     .data()['last_msg'];
                                  // var friendUnread = snapshot.data!.docs[index]
                                  //     .data()['unread_message'];
                                  // var friendIsText = snapshot.data!.docs[index]
                                  //     .data()['isText'];
                                  return Container(
                                    // padding: const EdgeInsets.all(15),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.3,
                                              color:
                                                  secondary.withOpacity(0.15))),
                                    ),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("messages")
                                          .doc(friendId)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              snap) {
                                        if (snap.hasData) {
                                          return
                                              // Text(
                                              //     "${snap.data!.data()!['isText']}");
                                              // Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.spaceAround,
                                              //     children: [
                                              //   SizedBox(
                                              //     height: size.height * 0.12,
                                              //     width: size.width * 0.12,
                                              //     child: ClipOval(
                                              //       child: SvgPicture.network(
                                              //           // height: size.height * 0.07,
                                              //           // width: size.width * 0.09,
                                              //           //    fit: BoxFit.fill,
                                              //           snap.data!.data()!['avatar']),
                                              //     ),
                                              //   ),
                                              //   Column(
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.start,
                                              //     children: [
                                              //       Text(
                                              //         "${snap.data!.data()!['username']}",
                                              //         style: const TextStyle(
                                              //             color: textColor,
                                              //             fontSize: 18),
                                              //       ),
                                              //       snap.data!.data()!["isText"] ==
                                              //               true
                                              //           ? Text(
                                              //               "${snap.data!.data()!['last_msg']}",
                                              //               style: TextStyle(
                                              //                   color: textColor),
                                              //             )
                                              //           : const Icon(Icons.image),
                                              //     ],
                                              //   ),
                                              //   Container(
                                              //     alignment: Alignment.center,
                                              //     height: size.height * 0.09,
                                              //     width: size.width * 0.09,
                                              //     decoration: BoxDecoration(
                                              //         border: Border.all(
                                              //             color: Colors.white),
                                              //         shape: BoxShape.circle,
                                              //         color: Colors.transparent),
                                              //     child: Text(
                                              //       '${snap.data!.data()!['unread_messages']}', // عرض عدد الرسائل
                                              //       style: const TextStyle(
                                              //           color: textColor,
                                              //           fontSize: 16),
                                              //     ),
                                              //   )
                                              // ]);
                                              InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) => ChatScreen(
                                                              full_name: snap
                                                                      .data!
                                                                      .data()![
                                                                  'username'],
                                                              receiverId:
                                                                  friendId,
                                                              avatar:
                                                                  friendAvatar)));
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: size.height * 0.12,
                                                width: size.width * 0.12,
                                                child: ClipOval(
                                                  child: Image.network(
                                                      // height: size.height * 0.07,
                                                      // width: size.width * 0.09,
                                                      // fit: BoxFit.fill,
                                                      snap.data!
                                                          .data()!['avatar']),
                                                ),
                                              ),
                                              title: Text(
                                                "${snap.data!.data()!['username']}",
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: 18),
                                              ),
                                              subtitle: snap.data!
                                                          .data()!["isText"] ==
                                                      true
                                                  ? Text(
                                                      "${snap.data!.data()!['last_msg']}",
                                                      style: TextStyle(
                                                          color: textColor),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(Icons.image),
                                                      ],
                                                    ),
                                              // trailing: Container(
                                              //   alignment: Alignment.center,
                                              //   height: size.height * 0.09,
                                              //   width: size.width * 0.09,
                                              //   decoration: BoxDecoration(
                                              //       border: Border.all(
                                              //           color: Colors.white),
                                              //       shape: BoxShape.circle,
                                              //       color: Colors.transparent),
                                              //   child: Text(
                                              //     '${snap.data!.data()!['unread_message']}', // عرض عدد الرسائل
                                              //     style: const TextStyle(
                                              //         color: textColor,
                                              //         fontSize: 16),
                                              //   ),
                                              // ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }
                        //  },
                        ))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class CardMessage extends StatefulWidget {
  const CardMessage({Key? key, required this.usersChat}) : super(key: key);
  final UsersChat usersChat;

  @override
  State<CardMessage> createState() => _CardMessageState();
}

class _CardMessageState extends State<CardMessage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.3,
            color: secondary.withOpacity(0.1),
          ),
        ),
      ),
      child: ListTile(
        leading:
            //  CircleAvatar(
            //   backgroundImage: NetworkImage(images[i]),
            //   radius: 30,
            // ),
            Container(
                // height: size.height * 0.2,
                // width: size.width * 0.15,
                child: ClipOval(
          child: SvgPicture.network(
              height: size.height * 0.07,
              width: size.width * 0.09,
              fit: BoxFit.fill,
              widget.usersChat.avatar),
        )),
        title: Text(
          widget.usersChat.name,
          style: const TextStyle(color: textColor, fontSize: 22),
        ),
        subtitle: widget.usersChat.msg.isNotEmpty
            ? Uri.parse(widget.usersChat.msg.last).isAbsolute
                ? const Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.image),
                  )
                : Text(
                    widget.usersChat.msg.last,
                    style: const TextStyle(color: textColor, fontSize: 14),
                  )
            : const Text(
                '',
                style: TextStyle(color: textColor, fontSize: 14),
              ),
        trailing: Container(
          alignment: Alignment.center,
          height: size.height * 0.09,
          width: size.width * 0.09,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
              color: Colors.transparent),
          child: Text(
            '${widget.usersChat.msg.length}', // عرض عدد الرسائل
            style: const TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
