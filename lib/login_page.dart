import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/colors.dart';
import 'package:new_project/home_page.dart';
import 'package:new_project/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ignore: must_be_immutable
class LogInPage extends StatefulWidget {
  LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  bool isRemember = false;
  final ios = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future<UserCredential?> signInWithEmailAndPassword(
        String email, String password) async {
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        if (email == "" || password == "") return null;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          // FirebaseFirestore.instance
          //     .collection('user')
          //     .doc(FirebaseAuth
          //         .instance.currentUser!.uid)
          //     .set({
          //   'avatar':
          //       "https://firebasestorage.googleapis.com/v0/b/easymoney-17c05.appspot.com/o/Group%2037172.svg?alt=media&token=47a4b7ef-0e79-4551-8498-f7c1b65aa178",
          //   "background": "",
          //   'email': email,
          //   "followers": 0,
          //   "following": 0,
          //   "full_name": email,
          //   "isAdmin": false,
          //   "phone": 5555555555,
          //   "uid": FirebaseAuth
          //       .instance.currentUser!.uid,
          //   "plan": "free",
          //   "startAt": DateTime.now(),
          //   "username": email,
          //   // Add other user-related data as needed
          // });
          await sharedPreferences!.setBool("remember", isRemember);
          // User is successfully logged in, navigate to the home page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        print('User logged in with email: ${userCredential.user!.email}');
        return userCredential;
      } catch (e) {
        print('Error signing in with email and password: $e');
        return null;
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: praimry,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ios
            ? SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: SvgPicture.asset(
                          "images/easyunilogo2.svg",
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Welcome!",
                          style: TextStyle(color: textColor, fontSize: 36),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            Text(
                              "Please log in to your ",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            Text(
                              " VIP",
                              style: TextStyle(color: greenColor, fontSize: 16),
                            ),
                            Text(
                              " account...",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: Container(
                        height: size.height * 0.67,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: secondary.withOpacity(0.03)),
                        margin: EdgeInsets.only(
                            top: size.height * 0.03,
                            bottom: size.height * 0.05),
                        // height: size.height * 0.58,
                        width: size.width * 0.90,
                        child: Stack(children: [
                          Positioned(
                            left: 1,
                            bottom: 0,
                            child: Container(
                              width: size.width * 0.55,
                              height: size.height * 0.55,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: secondary.withOpacity(0.19),
                                      spreadRadius: 10,
                                      offset: const Offset(-5, 200),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 60)
                                ],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: Container(
                              width: size.width * 0.55,
                              height: size.height * 0.55,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: secondary.withOpacity(0.15),
                                      spreadRadius: 10,
                                      offset: const Offset(50, -150),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 60)
                                ],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            // ignore: sort_child_properties_last
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: secondary.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: size.width * 0.86,
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    controller: emailController,
                                    style: const TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            const BorderSide(color: secondary),
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                        color: textColor,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondary.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: size.width * 0.86,
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: passwordController,
                                  style: const TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(
                                      color: textColor,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none),
                                  ),
                                  obscureText: true,
                                  // keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Square border radius
                                          ),
                                          value: isRemember,
                                          onChanged: (val) {
                                            setState(() {
                                              isRemember = val!;
                                              print(isRemember);
                                            });
                                          },
                                          activeColor: secondary,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          side: const BorderSide(
                                              color: Color(0xffCECFD1),
                                              width: 1.2),
                                        ),
                                        const Text(
                                          "Remember me",
                                          style: TextStyle(color: textColor),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.04,
                                    ),
                                    const Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: textColor),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await signInWithEmailAndPassword(
                              //         emailController.text, passwordController.text);
                              //   },
                              //   child: Text(
                              //     'Log in',
                              //     style: TextStyle(color: textColor),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     fixedSize: Size(size.width * 0.8, size.height * 0.07),
                              //     backgroundColor: secondary,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //           40.0), // Set the border radius
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16.0),
                              //   ),
                              // ),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await signInWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text);
                                  },
                                  child: SvgPicture.asset(
                                      "images/loginButton.svg")),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [greenColor, Color(0xff111A21)],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  const Text(
                                    " or ",
                                    style: TextStyle(color: textColor),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xff111A21), greenColor],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),

                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    final result = await SignInWithApple
                                        .getAppleIDCredential(
                                      scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName,
                                      ],
                                    );

                                    final oauthCredential =
                                        OAuthProvider('apple.com').credential(
                                      idToken: result.identityToken,
                                      accessToken: result.authorizationCode,
                                    );

                                    final UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithCredential(
                                                oauthCredential);

                                    if (userCredential.user != null) {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(user.uid)
                                            .set({
                                          'avatar':
                                              'https://firebasestorage.googleapis.com/v0/b/easymoney-17c05.appspot.com/o/Group%2037172.svg?alt=media&token=47a4b7ef-0e79-4551-8498-f7c1b65aa178',
                                          'background': '',
                                          'email': user.email,
                                          'followers': 0,
                                          'following': 0,
                                          'full_name': user.displayName,
                                          'isAdmin': false,
                                          'phone': 5555555555,
                                          'uid': user.uid,
                                          'plan': 'free',
                                          'startAt': DateTime.now(),
                                          'username': user.displayName,
                                        });
                                      }
                                      await sharedPreferences!
                                          .setBool("remember", isRemember);

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (route) => false,
                                      );
                                      print(
                                          'تم تسجيل الدخول بنجاح باستخدام حساب Apple!');
                                    } else {
                                      print('فشل تسجيل الدخول بحساب Apple');
                                    }
                                  } catch (error) {
                                    print(
                                        'حدث خطأ أثناء تسجيل الدخول بحساب Apple: $error');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      size.width * 0.6, size.height * 0.064),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40.0), // Set the border radius
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0.0),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.apple,
                                      color: Colors.black,
                                      size: 34,
                                    ),
                                    Text(
                                      '   Log in with Apple',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "By logging in, you agree to Easy Money ",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: textColor,
                                          )),
                                      Row(
                                        children: [
                                          Text("University",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: textColor,
                                              )),
                                          Text(
                                            ' Conditions & Terms.',
                                            style: TextStyle(
                                              decorationColor: Colors.green,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          )
                        ]),
                      ))
                    ]),
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: SvgPicture.asset(
                          "images/easyunilogo2.svg",
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Welcome!",
                          style: TextStyle(color: textColor, fontSize: 36),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            Text(
                              "Please log in to your ",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            Text(
                              " VIP",
                              style: TextStyle(color: greenColor, fontSize: 16),
                            ),
                            Text(
                              " account...",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: Container(
                        height: size.height * 0.67,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: secondary.withOpacity(0.03)),
                        margin: EdgeInsets.only(
                            top: size.height * 0.03,
                            bottom: size.height * 0.05),
                        // height: size.height * 0.58,
                        width: size.width * 0.90,
                        child: Stack(children: [
                          Positioned(
                            left: 1,
                            bottom: 0,
                            child: Container(
                              width: size.width * 0.55,
                              height: size.height * 0.55,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: secondary.withOpacity(0.19),
                                      spreadRadius: 10,
                                      offset: const Offset(-5, 200),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 60)
                                ],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: Container(
                              width: size.width * 0.55,
                              height: size.height * 0.55,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: secondary.withOpacity(0.15),
                                      spreadRadius: 10,
                                      offset: const Offset(50, -150),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 60)
                                ],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            // ignore: sort_child_properties_last
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: secondary.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: size.width * 0.86,
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    controller: emailController,
                                    style: const TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            const BorderSide(color: secondary),
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                        color: textColor,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondary.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: size.width * 0.86,
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: passwordController,
                                  style: const TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(
                                      color: textColor,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none),
                                  ),
                                  // keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Square border radius
                                          ),
                                          value: isRemember,
                                          onChanged: (val) {
                                            setState(() {
                                              isRemember = val!;
                                              print(isRemember);
                                            });
                                          },
                                          activeColor: secondary,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          side: const BorderSide(
                                              color: Color(0xffCECFD1),
                                              width: 1.2),
                                        ),
                                        const Text(
                                          "Remember me",
                                          style: TextStyle(color: textColor),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.04,
                                    ),
                                    const Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: textColor),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await signInWithEmailAndPassword(
                              //         emailController.text, passwordController.text);
                              //   },
                              //   child: Text(
                              //     'Log in',
                              //     style: TextStyle(color: textColor),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     fixedSize: Size(size.width * 0.8, size.height * 0.07),
                              //     backgroundColor: secondary,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //           40.0), // Set the border radius
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16.0),
                              //   ),
                              // ),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {},
                                  child: SvgPicture.asset(
                                      "images/loginButton.svg")),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [greenColor, Color(0xff111A21)],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  const Text(
                                    " or ",
                                    style: TextStyle(color: textColor),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xff111A21), greenColor],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),

                              ElevatedButton(
                                onPressed: () async {
                                  // Initialize GoogleSignIn instance
                                  final GoogleSignInAccount? googleUser =
                                      await GoogleSignIn().signIn();

                                  // Authenticate with Firebase using GoogleSignInAccount
                                  if (googleUser != null) {
                                    final GoogleSignInAuthentication
                                        googleAuth =
                                        await googleUser.authentication;
                                    final AuthCredential credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );

                                    // Sign in to Firebase with Google credentials
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false, // Remove all routes
                                    );
                                    print('User signed in with Google!');
                                  } else {
                                    print('Google Sign-In failed');
                                  }
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set({
                                      'avatar':
                                          "https://firebasestorage.googleapis.com/v0/b/easymoney-17c05.appspot.com/o/Group%2037172.svg?alt=media&token=47a4b7ef-0e79-4551-8498-f7c1b65aa178",
                                      "background": "",
                                      'email': user.email,
                                      "followers": 0,
                                      "following": 0,
                                      "full_name": user.displayName,
                                      "isAdmin": false,
                                      "phone": 5555555555,
                                      "uid": FirebaseAuth
                                          .instance.currentUser!.uid,
                                      "plan": "free",
                                      "startAt": DateTime.now(),
                                      "username": user.displayName,
                                      // Add other user-related data as needed
                                    }).then((_) {
                                      print('User added to Firestore!');
                                    }).catchError((error) {
                                      print(
                                          'Error adding user to Firestore: $error');
                                    });
                                  }
                                  await sharedPreferences!
                                      .setBool("remember", isRemember);
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      size.width * 0.6, size.height * 0.064),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40.0), // Set the border radius
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "images/google.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                    const Text(
                                      '   Log in with Google',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "By logging in, you agree to Easy Money ",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: textColor,
                                          )),
                                      Row(
                                        children: [
                                          Text("University",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: textColor,
                                              )),
                                          Text(
                                            ' Conditions & Terms.',
                                            style: TextStyle(
                                              decorationColor: Colors.green,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          )
                        ]),
                      ))
                    ]),
              ),
      ),
    );
  }
}
//  'By logging in, you agree to Easy Money \'s University'
  //  Text(
  //                             ' Conditions & Terms.',
  //                             style: TextStyle(
  //                               decoration: TextDecoration.underline,
  //                               color: Colors
  //                                   .green, // Set green color for this portion
  //                             ),
  //                           ),