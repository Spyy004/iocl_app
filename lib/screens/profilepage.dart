import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iocl_app/utils/consts.dart';

import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = loggedInUser?['name'];
    passwordController.text = loggedInUser?['emailId'];
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              child: Image(
                image: AssetImage("assets/iocl_cover.png"),

              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            TextFormField(
                controller: emailController,
                validator: (value) {},
                enabled: isEditing,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: loggedInUser?['name'] ,
                )),
            SizedBox(
              height: height * 0.03,
            ),
            TextFormField(
                enabled: isEditing,
                controller: passwordController,
                validator: (value) {},
                decoration:  InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: currentUser!.email,
                 )),
            SizedBox(
              height: height * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () async{
                    if(isEditing) {
                        db.collection('user').doc(loggedInUser?['empCode']).update(
                            {
                              'name': emailController.text,
                              'emailId':passwordController.text

                            }
                            );
                    }
                      setState(() {
                        isEditing = !isEditing;
                      });


                  },
                  child: isEditing ? Text("Save Profile"):Text("Edit Profile"),
                ),
                SizedBox(width: width*0.06,),
                OutlinedButton(
                  onPressed: (){
                    FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser!.email.toString());
                    showGenericToast("Password reset email sent");
                  },
                  child: Text("Forgot Password"),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: (){
                loggedInUser = {};
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Logout"),
            ),


          ],
        ),
      ),
    );
  }
}
