import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDOB;

  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;


  Future<void> _reauthenticate() async {
    final passwordController = TextEditingController();

   
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Re-authenticate'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: "Enter your current password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('OK'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
  
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: passwordController.text.trim(),
      );

      try {
        await user?.reauthenticateWithCredential(credential);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Re-authentication failed: $e")),
        );
        throw e;
      }
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }


  void changePassword(BuildContext context) async {
    try {
      await _reauthenticate(); 
      final email = user?.email;
      if (email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset email sent to $email")),
        );
      }
    } catch (e) {
  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send reset email: $e")),
      );
    }
  }


  void updateEmail() async {
    try {
      await _reauthenticate(); 
      await user?.updateEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating email: $e")),
      );
    }
  }

  void updateDOB() async {
    if (_selectedDOB == null) return;

    try {
      await firestore.collection('users').doc(user!.uid).update({
        'dob': _selectedDOB!.toIso8601String(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("DOB updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update DOB: $e")),
      );
    }
  }


  Future<void> pickDOB(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDOB = picked;
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => changePassword(context),
              child: Text("Change Password"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "New Email"),
            ),
            ElevatedButton(
              onPressed: updateEmail,
              child: Text("Update Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dobController,
              readOnly: true,
              onTap: () => pickDOB(context),
              decoration: InputDecoration(
                labelText: "Date of Birth",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            ElevatedButton(
              onPressed: updateDOB,
              child: Text("Update DOB"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logout(context),
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
