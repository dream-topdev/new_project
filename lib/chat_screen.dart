import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_project/colors.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {Key? key,
      // ignore: non_constant_identifier_names
      required this.full_name,
      required this.receiverId,
      required this.avatar})
      : super(key: key);
  // ignore: non_constant_identifier_names
  final String full_name;

  final String receiverId;
  final String avatar;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLastMsgRead = false;
  void getLastMsg() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseFirestore.instance
          .collection("user")
          .doc(widget.receiverId)
          .collection("messages")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("chats")
          .orderBy("time", descending: false)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          setState(() {
            isLastMsgRead = value.docs.last['isRead'];
          });
        }
      });
      //   print(isLastMsgRead);
    });
  }

  void updateLastMsgReadStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("messages")
          .doc(widget.receiverId)
          .collection("chats")
          .orderBy("time",
              descending: true) // Order by time to get the last message
          .limit(1) // Retrieve only one document (the last one)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Get the reference of the last message document
          DocumentReference lastMessageRef = querySnapshot.docs.first.reference;

          // Update the 'isRead' field of the last message document
          lastMessageRef.update({'isRead': true}).then((value) {
            print('Last message updated as read');
          }).catchError((error) {
            print('Error updating last message: $error');
            print(error.stackTrace);
          });
        } else {
          print('No documents found in the query');
        }
      }).catchError((error) {
        print('Error querying last message: $error');
        print(error.stackTrace);
      });
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _msgCon = TextEditingController();
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final chat = FirebaseFirestore.instance;
  CollectionReference userChat =
      FirebaseFirestore.instance.collection('userChat');
  FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode messageFocusNode = FocusNode();
  final ios = Platform.isIOS;
  var chatDocId;
  bool enableSendButton = false;
  int? currentNumber;
  int? increamented;
  @override
  void initState() {
    print("${widget.receiverId}******************");
    getUserAvatar();
    resetMessages();
    getUsername();
    getLastMsg();
    updateLastMsgReadStatus();

    //  checkUser();
    super.initState();
  }

  void resetMessages() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
      ..doc(widget.receiverId).update({
        'avatar': widget.avatar,
        "unread_message": 0,
        "isText": true,
        "uid": widget.receiverId,
        'isRead': false,
        'username': widget.full_name
      }).then((value) => print("reset done *********"));
  }

  //فتح خانة جديده
  // void checkUser() async {
  //   final userData = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: auth.currentUser!.email)
  //       .get();
  //   String username = '';
  //   if (userData.docs.isNotEmpty) {
  //     setState(() {
  //       username = userData.docs.first.get('username');
  //     });
  //   }

  //   final querySnapshot = await chats
  //       .where('users', isEqualTo: {
  //         widget.full_name: widget.email,
  //         username: auth.currentUser!.email
  //       })
  //       .limit(1)
  //       .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     setState(() {
  //       chatDocId = querySnapshot.docs.first.id;
  //     });

  //     print(chatDocId);
  //   } else {
  //     // final docRef = await chats.add({
  //     //   'users': {
  //     //     username: auth.currentUser!.email,
  //     //     widget.full_name: widget.email
  //     //   },
  //     // });
  //     setState(() {
  //       chatDocId = docRef.id;
  //     });
  //   }
  // }

  //للارسال الرسالة
  Future<void> sendMessage(String msg) async {
    // final emailToCheck = (auth.currentUser!.email == widget.email)
    //     ? auth.currentUser!.email
    //     : widget.email;

    // final toCheck = (widget.email == auth.currentUser!.email)
    //     ? widget.email
    //     : auth.currentUser!.email;
    if (msg == '') return;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await chat
        .collection("user")
        .doc(widget.receiverId)
        .collection("messages")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      currentNumber = snapshot.data()!['unread_message'];
      increamented = currentNumber! + 1;
    }

    await chat
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(widget.receiverId)
        .collection('chats')
        .add({
      'time': Timestamp.now(),
      'msg': msg,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "receiverId": widget.receiverId,
      "isText": true,
      'isRead': false,
      'email': auth.currentUser!.email
    }).then((value) {
      chat
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(widget.receiverId)
          .set({
        'last_msg': msg,
        'avatar': widget.avatar,
        "unread_message": 0,
        "isText": true,
        "uid": widget.receiverId,
        'isRead': false,
        'username': widget.full_name
      });
    });
    chat
        .collection('user')
        .doc(widget.receiverId)
        .collection('messages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .add({
      'time': Timestamp.now(),
      'msg': msg,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "receiverId": widget.receiverId,
      "isText": true,
      'isRead': false,
      'email': auth.currentUser!.email
    }).then((value) {
      chat
          .collection('user')
          .doc(widget.receiverId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'last_msg': msg,
        'avatar': myAvatar,
        "unread_message": increamented ?? 0,
        "isText": true,
        "username": username,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        'isRead': false,
      });
    });
  }

  String? myAvatar;
  String? username;

  void getUserAvatar() async {
    QuerySnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection("user").get();

    var userData = query.docs.firstWhere(
        (element) => element["uid"] == FirebaseAuth.instance.currentUser!.uid);
    myAvatar = userData.data()["avatar"];
    print("$myAvatar ===========");
  }

  void getUsername() async {
    QuerySnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection("user").get();

    var userData = query.docs.firstWhere(
        (element) => element["uid"] == FirebaseAuth.instance.currentUser!.uid);
    username = userData.data()["username"];
    print("$username ===========");
  }

//   await chats
//       .doc(chatDocId)
//       .collection('user')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection("chats")
//       .doc("${widget.receiverId}")
//       .collection("message")
//       .add({
//     'time': Timestamp.now(),
//     'msg': msg,
//     "senderId": FirebaseAuth.instance.currentUser!.uid,
//     "receiverId": widget.receiverId,
//     'email': auth.currentUser!.email
//   }).then((value) {
//     addMessage(widget.full_name, toCheck, emailToCheck, msg, widget.avatar);
//   });
// }

  // void addMessage(
  //     String fullName, toCheck, emailToCheck, String msg, String avatar) {
  //   userChat.doc('${toCheck},${emailToCheck}').set({
  //     'name': fullName,
  //     'email': toCheck,
  //     'recipient': emailToCheck,
  //     'msg': FieldValue.arrayUnion([msg]),
  //     'time': Timestamp.now(),
  //     'avatar': avatar,
  //     'isRead': false,
  //   }, SetOptions(merge: true));
  // }

//للارسال الصور
  Future<void> _uploadMedia(File imageFile) async {
    // final emailToCheck = (auth.currentUser!.email == widget.email)
    //     ? auth.currentUser!.email
    //     : widget.email;

    // final toCheck = (widget.email == auth.currentUser!.email)
    //     ? widget.email
    //     : auth.currentUser!.email;

    String fileName = const Uuid().v1();
    var ref = FirebaseStorage.instance.ref().child('chats').child(fileName);
    var uploadTask = await ref.putFile(imageFile);
    String mediaUrl = await uploadTask.ref.getDownloadURL();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await chat
        .collection("user")
        .doc(widget.receiverId)
        .collection("messages")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      currentNumber = snapshot.data()!['unread_message'];
      increamented = currentNumber! + 1;
    }

    chat
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .doc(widget.receiverId)
        .collection("chats")
        .add({
      'time': Timestamp.now(),
      'msg': mediaUrl,
      "isText": false,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "receiverId": widget.receiverId,
      'isRead': false,
      'email': auth.currentUser!.email
    }).then((value) {
      chat
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(widget.receiverId)
          .set({
        'last_msg': "image",
        "unread_message": 0,
        "username": widget.full_name,
        "isText": false,
        "uid": widget.receiverId,
        'avatar': widget.avatar,
        'isRead': false,
      });
    });
    chat
        .collection('user')
        .doc(widget.receiverId)
        .collection("messages")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .add({
      'time': Timestamp.now(),
      'msg': mediaUrl,
      "isText": false,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "receiverId": widget.receiverId,
      'email': auth.currentUser!.email
    }).then((value) {
      chat
          .collection('user')
          .doc(widget.receiverId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'last_msg': "image",
        "unread_message": increamented ?? 0,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "isText": false,
        "username": username,
        'avatar': myAvatar,
      });
    });
  }

  Future<void> sendMedia() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        File mediaFile = File(xFile.path);
        _uploadMedia(mediaFile);
      }
    });
  }

  Future<void> sendMediaFromCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) async {
      if (xFile != null) {
        File mediaFile = File(xFile.path);
        _uploadMedia(mediaFile);
      }
    });
  }

  bool isSender(String friend) {
    return friend == FirebaseAuth.instance.currentUser!.email;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondary.withOpacity(0.03),
      appBar: AppBar(
        // actions: [
        //   Container(
        //       alignment: Alignment.center,
        //       height: size.height * 0.12,
        //       width: size.width * 0.12,
        //       margin: const EdgeInsets.only(right: 10),
        //       decoration: BoxDecoration(
        //           border: Border.all(color: praimry),
        //           shape: BoxShape.circle,
        //           color: greenColor.withOpacity(0.05)),
        //       child:
        //           //  Image.asset(
        //           //   "images/info.png",
        //           //   width: size.width * 0.03,
        //           //   height: size.height * 0.03,
        //           //   fit: BoxFit.fill,
        //           // ),
        //           SvgPicture.asset(
        //         "images/info.svg",
        //         height: 30,
        //         width: 20,
        //       )),
        //   Container(
        //       alignment: Alignment.center,
        //       height: size.height * 0.14,
        //       width: size.width * 0.13,
        //       margin: const EdgeInsets.only(right: 15),
        //       decoration: BoxDecoration(
        //         border: Border.all(color: praimry),
        //         shape: BoxShape.circle,
        //         // color: greenColor.withOpacity(0.1)
        //       ),
        //       child:
        //           //  Image.asset(
        //           //   "images/info.png",
        //           //   width: size.width * 0.03,
        //           //   height: size.height * 0.03,
        //           //   fit: BoxFit.fill,
        //           // ),
        //           SvgPicture.asset(
        //         "images/call.svg",
        //         height: 50,
        //         width: 50,
        //       ))
        // ],
        leading: ios
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        //    Icons.arrow_back,
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Color(0xff0A84FF),
                      )),
                ],
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  // Icons.arrow_back_ios,
                  size: 25,
                  color: greenColor,
                )),

        title: Row(
          children: [
            ClipOval(
              child: Container(
                // height: size.height * 0.09,
                // width: size.width * 0.07,

                child: Image.network(
                  height: 48,
                  width: 48,
                  '${widget.avatar}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.full_name}",
                  style: const TextStyle(color: textColor, fontSize: 16),
                ),
                const Text(
                  "Online",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.4),
        // elevation: 0,
//        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                        height: size.height * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: secondary.withOpacity(0.1),
                                spreadRadius: 10,
                                offset: const Offset(50, 40),
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
                                offset: const Offset(-20, 80),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: chat
                            .collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("messages")
                            .doc(widget.receiverId)
                            .collection("chats")
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                bool isImage = map['isText'] == false;
                                final time = DateFormat('h:mm a')
                                    .format((map['time']).toDate());
                                return Column(
                                  children: [
                                    if (isImage)
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child:
                                              isSender(map['email'].toString())
                                                  ? Column(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            time,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              width: 120,
                                                              height: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            17),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            17),
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      250 / 330,
                                                                  child: Image.network(map['msg'], fit: BoxFit.cover, loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: isSender(map['email'].toString())
                                                                            ? Colors.green
                                                                            : Colors.grey,
                                                                      ),
                                                                    );
                                                                  }, errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          exception,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error_outline_outlined,
                                                                        color: isSender(map['email'].toString())
                                                                            ? Colors.white
                                                                            : Colors.blueGrey,
                                                                        size:
                                                                            40,
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                            ),
                                                            FutureBuilder(
                                                              future: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "user")
                                                                  .where("uid",
                                                                      isEqualTo: FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                  .get(),
                                                              builder: (context,
                                                                  AsyncSnapshot
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    // height: size.height * 0.09,
                                                                    // width: size.width * 0.07,
                                                                    child: ClipOval(
                                                                        child: SvgPicture.network(
                                                                            height: size.height *
                                                                                0.06,
                                                                            width:
                                                                                size.width * 0.02,
                                                                            '${widget.avatar}')),
                                                                  );
                                                                }
                                                                return const Center();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            time,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FutureBuilder(
                                                              future: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "user")
                                                                  .where("uid",
                                                                      isEqualTo: FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                  .get(),
                                                              builder: (context,
                                                                  AsyncSnapshot
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    // height: size.height * 0.09,
                                                                    // width: size.width * 0.07,
                                                                    child: ClipOval(
                                                                        child: SvgPicture.network(
                                                                            height: size.height *
                                                                                0.06,
                                                                            width:
                                                                                size.width * 0.02,
                                                                            '${widget.avatar}')),
                                                                  );
                                                                }
                                                                return const Center();
                                                              },
                                                            ),
                                                            Container(
                                                              width: 120,
                                                              height: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            17),
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      250 / 330,
                                                                  child: Image.network(map['msg'], fit: BoxFit.cover, loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: isSender(map['email'].toString())
                                                                            ? Colors.green
                                                                            : Colors.grey,
                                                                      ),
                                                                    );
                                                                  }, errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          exception,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error_outline_outlined,
                                                                        color: isSender(map['email'].toString())
                                                                            ? Colors.white
                                                                            : Colors.blueGrey,
                                                                        size:
                                                                            40,
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                    else
                                      Container(
                                        child: isSender(map['email'].toString())
                                            ? buildSenderMessage(
                                                map['msg'],
                                                const Color(0xff1EA25B),
                                                time,
                                                map['isRead'])
                                            : buildReceiverMessage(
                                                map['msg'],
                                                const Color(0xff5D5D5D),
                                                time,
                                              ),
                                      ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Container(); // يمكنك استبدال هذا بأي عنصر واجهة مستخدم آخر يعكس حالة عدم توفر بيانات الصورة.
                          }
                        },
                      ),
                    ),

                    SafeArea(
                        child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          !ios
                              ? Expanded(
                                  flex: !enableSendButton ? 1 : 0,
                                  child: !enableSendButton
                                      ? InkWell(
                                          child: const Icon(
                                              color: const Color(0xffA2C9FF),
                                              Icons.camera_alt),
                                          onTap: () {
                                            sendMediaFromCamera();
                                          },
                                        )
                                      : Container())
                              : Container(),
                          !ios
                              ? Expanded(
                                  flex: !enableSendButton ? 1 : 0,
                                  child: !enableSendButton
                                      ? IconButton(
                                          icon: const Icon(Icons.image),
                                          color: const Color(0xffA2C9FF),
                                          onPressed: () {
                                            messageFocusNode.unfocus();
                                            sendMedia();
                                          },
                                        )
                                      : Container())
                              : Container(),
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
                          ios
                              ? IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      enableSendButton = false;
                                      _msgCon.clear();
                                    });
                                    await sendMessage(_msgCon.text);
                                  },
                                  icon: const Icon(Icons.send),
                                  iconSize: 25,
                                  color: Colors.white,
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xff1EA25B))),
                                )
                              : Expanded(
                                  flex: enableSendButton ? 1 : 0,
                                  child: enableSendButton
                                      ? InkWell(
                                          onTap: () async {
                                            print(_msgCon.text);
                                            await sendMessage(_msgCon.text);
                                            setState(() {
                                              enableSendButton = false;
                                              _msgCon.clear();
                                            });
                                          },
                                          child:
                                              // SvgPicture.asset(
                                              //   "images/ButtonIosSend.svg",
                                              //   height: 60,
                                              //   fit: BoxFit.fill,
                                              //   width: 50,
                                              // )
                                              SvgPicture.asset(
                                                  "images/sendButton.svg"))
                                      : Container())
                        ],
                      ),
                    ))
                    // : Container(
                    //     padding: EdgeInsets.all(8),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           flex: 6,
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(right: 5),
                    //             child: SizedBox(
                    //               height: size.height * 0.06,
                    //               child: TextField(
                    //                 onChanged: (val) {
                    //                   if (val.isEmpty) {
                    //                     setState(() {
                    //                       enableSendButton = !enableSendButton;
                    //                       print("send");
                    //                     });
                    //                   }
                    //                 },
                    //                 cursorColor: Color(0xffA2C9FF),
                    //                 controller: _msgCon,
                    //                 style: TextStyle(color: textColor),
                    //                 decoration: InputDecoration(
                    //                   fillColor: secondary.withOpacity(0.1),
                    //                   filled: true,
                    //                   hintText: ' Message',
                    //                   hintStyle: GoogleFonts.roboto(
                    //                     color: Color(0xffA8ADBD),
                    //                   ),
                    //                   // TextStyle(color: Color(0xffA8ADBD)),
                    //                   contentPadding: EdgeInsets.symmetric(
                    //                       horizontal: 16.0), // Adjust padding
                    //                   // Center align the hint text

                    //                   alignLabelWithHint: true,

                    //                   border: OutlineInputBorder(
                    //                     borderSide: BorderSide.none,
                    //                     borderRadius: BorderRadius.circular(25.0),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: SvgPicture.asset("images/sendButton.svg"),
                    //           flex: 1,
                    //         )
                    //       ],
                    //     ),
                    //   )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        controller: _msgCon,
        decoration: InputDecoration(
          fillColor: secondary.withOpacity(0.1),
          filled: true,
          prefixIcon: ios
              ? const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.grey,
                )
              : null,
          suffix: ios
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        messageFocusNode.unfocus();
                        sendMedia();
                      },
                      child: ios
                          ? SvgPicture.asset("images/gallareyIos.svg")
                          : null,
                    ),
                    const Icon(
                      Icons.mic,
                      color: Colors.grey,
                    )
                  ],
                )
              : null,
          hintText: ' Message',
          hintStyle: const TextStyle(color: Color(0xffA8ADBD)),
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

  Widget buildReceiverMessage(
    String message,
    Color color,
    timestamp,
  ) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '$timestamp',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            Row(
              children: [
                Container(
                  // height: size.height * 0.09,
                  // width: size.width * 0.07,
                  child: ClipOval(
                      child: SvgPicture.network(
                          height: size.height * 0.06,
                          width: size.width * 0.02,
                          '${widget.avatar}')),
                ),
                Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),

                  // Text(
                  //   '8:30 AM',
                  //   style: TextStyle(color: Colors.white70),
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSenderMessage(
      String message, Color color, timestamp, bool isRead) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(
                '$timestamp',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isRead == false
                    ? SvgPicture.asset(
                        "images/unredSelected.svg",
                        height: 15,
                      )
                    : SvgPicture.asset(
                        "images/Selected.svg",
                        height: 15,
                      ),
                Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    message,
                    style: const TextStyle(color: textColor),
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection("user").get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    var userData = snapshot.data?.docs.firstWhere((element) =>
                        element["uid"] ==
                        FirebaseAuth.instance.currentUser!.uid);
                    if (snapshot.hasData) {
                      return Container(
                        // height: size.height * 0.09,
                        // width: size.width * 0.07,
                        child: ClipOval(
                            child: SvgPicture.network(
                                height: size.height * 0.06,
                                width: size.width * 0.02,
                                '${userData!['avatar']}')),
                      );
                    }
                    return const Center();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// buildReceiverMessage('Hello!', Color(0xff5D5D5D)),
//    buildSenderMessage('Hi there!', Color(0xff1EA25B)),
