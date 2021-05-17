import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  String email;
  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

String name = '';
String mobile = '';
String email = '';
int _currentIndex = 0;

class _HomePageState extends State<HomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    email = widget.email;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> tabs = [
      StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: Text(
                    document.get('name'),
                ),
                subtitle: Text(
                    document.get('email'),
                ),
                trailing: Text(
                  document.get('mobile'),
                ),
              );
            }).toList(),
          );
        },
      ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            'Update Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            'Enter Name:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
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
            'Enter your mobile number:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            style: TextStyle(
              fontSize: 20.0,
            ),
            keyboardType: TextInputType.number,
            maxLength: 10,
            onChanged: (value){
              mobile = '+91'+value;
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
          ElevatedButton(
            onPressed: (){
              users.doc(email).update(
                  {
                    'email': email,
                    'name': name,
                    'mobile': mobile,
                  }
              ).then((value) {
                setState(() {
                  _currentIndex = 0;
                });
              });
            },
            child: Text(
              'Update',
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
  ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Color(0xFF00d130),
          ),
          onPressed: (){
            auth.signOut();
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(
              Icons.dashboard,
              color: Color(0xFF00d130),
            ),
            backgroundColor: Color(0xFF00d130),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person,
              color: Color(0xFF00d130),
            ),
            backgroundColor: Color(0xFF00d130),
          ),
        ],
        onTap: (selectedIndex){
          setState(() {
            _currentIndex = selectedIndex;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}
