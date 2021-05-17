import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codingweek/pages/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

String email = '';
String password = '';

class _LoginPageState extends State<LoginPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Login',
          style: TextStyle(
            color: Color(0xFF00d130),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter email id:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontSize: 20.0,
              ),
              onChanged: (value){
                email = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xFF00d130),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Enter your Password:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            TextField(
              obscureText: true,
              style: TextStyle(
                fontSize: 20.0,
              ),
              onChanged: (value){
                password = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xFF00d130),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    try {
                      auth.signInWithEmailAndPassword(email: email, password: password)
                      .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(email: email,))));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF00d130)),
                  ),
                ),
              ],
            ),
            Divider( thickness: 3.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(
                  Buttons.Google,
                  onPressed: () async{
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    try {
                      await googleSignIn.signIn().
                      then((value) async{
                        final GoogleSignInAccount googleUser = value;
                        print(googleUser.email);
                        print(googleUser.displayName);
                        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken
                        );
                        auth.signInWithCredential(credential);
                        users.doc(googleUser.email).get().then((DocumentSnapshot documentSnapshot) {
                          if(documentSnapshot.exists){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(email: googleUser.email,)));
                          }
                          else{
                            users.doc(googleUser.email).set({
                              'name': googleUser.displayName,
                              'email': googleUser.email,
                              'mobile': 'To be updated',
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(email: googleUser.email,)));
                          }
                        });

                      });
                    } catch (error) {
                      print(error);
                    }
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
