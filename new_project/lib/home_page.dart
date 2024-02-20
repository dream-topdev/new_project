import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/colors.dart';
import 'package:new_project/login_page.dart';
import 'package:new_project/main.dart';
import 'package:new_project/messages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DocumentSnapshot? currentUserName;

  Future<void> getCurrentUsername() async {
    currentUserName = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    print("Username: ${currentUserName!['username']}");
  }

  @override
  Widget build(BuildContext context) {
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

    //  final height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    int _currentIndex = 0;
    // final List<Widget> _screens = [
    //   HomePage(),
    //   HomePage(),
    //   HomePage(),
    //   HomePage()
    // ];
    return Scaffold(
      key: _scaffoldKey,
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
      //                             '${snapshot.data!.data()['avatar']}')),
      //                   ),
      //                   title: Row(
      //                     children: [
      //                       Text(
      //                         "${snapshot.data.data()['username']}",
      //                         style:
      //                             TextStyle(color: textColor, fontSize: 16),
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
      backgroundColor: secondary.withOpacity(0.03),
      //secondary.withOpacity(0.05),
      body: HomeWidget(size: size, scaffoldKey: _scaffoldKey),
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
      //         BottomNavigationBarItem(
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
      // )
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required this.size,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final Size size;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                          color: secondary.withOpacity(0.1),
                          spreadRadius: 10,
                          offset: Offset(50, 40),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 70)
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
                          offset: Offset(-20, 80),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 570)
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
          children: [
            Container(
              color: Colors.black,
              width: size.width,
              height: size.height * 0.12,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Image.asset(
                    //   "images/easyunilogo1.png",
                    // height: 38.5,
                    // width: 140,
                    // fit: BoxFit.fill,
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
                    //       onTap: () =>
                    //           _scaffoldKey.currentState?.openEndDrawer(),
                    //       child:
                    //           // Image.asset(
                    //           // "images/jam_menu.png",
                    //           // height: size.height * 0.07,
                    //           // width: size.width * 0.1,
                    //           // ),
                    //           SvgPicture.asset(
                    //         "images/jam_menu.svg",
                    //         // height: size.height * 0.07,
                    //         // width: size.width * 0.1,
                    //       )),
                    // )
                  ]),
            ),
            Container(
                margin: EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    Text(
                      "Inbox Empty! ",
                      style: TextStyle(fontSize: 24, color: textColor),
                    ),
                    Text(
                      "Looks like you haven't started any chats yet ",
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Messages())),
                      child: Container(
                        // height: size.height * 0.07,
                        // width: size.width * 0.4,
                        // decoration: BoxDecoration(
                        //     //     color: secondary.withOpacity(0.1),
                        //     borderRadius: BorderRadius.horizontal(
                        //         left: Radius.circular(80),
                        //         right: Radius.circular(80))),
                        child: SvgPicture.asset(
                          "images/StartChat.svg",
                          height: size.height * 0.09,
                          fit: BoxFit.fill,
                        ),
                        // child: Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Image.asset(
                        //         "images/telegram.png",
                        //         width: 55,
                        //         color: Colors.green,
                        //         height: 33,
                        //       ),
                        //       Text(
                        //         "Start Chat",
                        //         style: TextStyle(
                        //             color: Colors.green, fontSize: 14),
                        //       )
                        //     ]),
                      ),
                    )
                  ],
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        )
      ],
    );
  }
}
