import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iocl_app/screens/homepage.dart';

import '../utils/consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showLoader = false;
  void loginUser() async {
    try {
      setState(() {
        showLoader = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      currentUser = credential.user;
      print(credential);
      showGenericToast("Welcome back!");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyHomePage(

        );
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showGenericToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showGenericToast('Wrong password provided for that user.');
      } else {
        showGenericToast(e.code);
      }
    } catch (e) {
      showGenericToast(e.toString());
    } finally {
      setState(() {
        showLoader = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Image(image: AssetImage("assets/iocl_cover.png"))),
            SizedBox(
              height: height * 0.1,
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    TextFormField(
                        controller: emailController,
                        validator: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                          labelText: 'Enter your email id',
                        )),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    TextFormField(
                        controller: passwordController,
                        validator: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                          labelText: 'Enter your password',
                        )),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                         loginUser();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: width * 0.3,
                            child: Center(
                                child: Text(
                              "Log In",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffED6B21))),
                            ))),
                      ),
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
