import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codingweek/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

String name = '';
String email = '';
String password = '';

class _SignUpPageState extends State<SignUpPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF00d130),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                onChanged: (value){
                  name = value;
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
                  'Enter your email address:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                keyboardType: TextInputType.emailAddress,
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
                  'Enter Password:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                obscureText: true,
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
              SizedBox(height: 10.0,),

              ElevatedButton(
                onPressed: () async{
                  try {
                    auth.createUserWithEmailAndPassword(email: email, password: password)
                        .then((value) {
                          users.doc(email).set({
                            'name': name,
                            'email': email,
                            'mobile': 'To be updated',
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(email: email,)));
                    }
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'Sign Up',
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
        ),
      ),
    );
  }
}
