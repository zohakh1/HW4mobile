import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String boardName;
  ChatScreen({required this.boardName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgCtrl = TextEditingController();

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final name = "${userDoc['firstName']} ${userDoc['lastName']}";

    await FirebaseFirestore.instance
        .collection('boards')
        .doc(widget.boardName)
        .collection('messages')
        .add({
      'message': msgCtrl.text,
      'sender': name,
      'timestamp': Timestamp.now(),
    });
    msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.boardName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('boards')
                  .doc(widget.boardName)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final messages = snapshot.data!.docs;
                return ListView(
                  children: messages.map((msg) {
                    return ListTile(
                      title: Text(msg['message']),
                      subtitle: Text("${msg['sender']} • ${msg['timestamp'].toDate()}"),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: msgCtrl)),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          )
        ],
      ),
    );
  }
}
