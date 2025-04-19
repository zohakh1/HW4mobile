import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final fnameCtrl = TextEditingController();
  final lnameCtrl = TextEditingController();
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      fnameCtrl.text = doc['firstName'];
      lnameCtrl.text = doc['lastName'];
      email = doc['email'];
    });
  }

  void updateProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'firstName': fnameCtrl.text,
      'lastName': lnameCtrl.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Email: $email", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(controller: fnameCtrl, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: lnameCtrl, decoration: InputDecoration(labelText: "Last Name")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateProfile, child: Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}
