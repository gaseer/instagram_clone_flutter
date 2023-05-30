import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:fast_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/features/presentation/page/chat/widget/message_widget.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

late User logUser;

class ChatScreen extends StatefulWidget {
  static const id = 'Chat';

  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final txtCon = TextEditingController();
  late String masg;
  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  void getUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    msgStream();
  }

  void msgStream() async {
    await for (var snp in _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()) {
      for (var message in snp.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                msgStream();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4.0,
                    ),
                  );
                }
                final msgs = snapshot.data?.docs;
                List<MessageWidget> msgWid = [];
                for (var msg in msgs!) {
                  final data = msg.data() as Map;
                  final mTx = data['text'];
                  final mSe = data['sender'];
                  final curuser = logUser.email;

                  final msWd = MessageWidget(
                    sen: mSe,
                    ms: mTx,
                    isMe: curuser == mSe,
                  );
                  msgWid.add(msWd);
                }
                msgWid =
                    msgWid.reversed.toList(); // Reverse the order of the list

                return Expanded(
                  child: ListView(
                    reverse: false,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    children: msgWid,
                  ),
                );
              },
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: txtCon,
                        onChanged: (value) {
                          masg = value;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          hintText: 'Message here...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      txtCon.clear();
                      _firestore.collection('messages').add({
                        'sender': logUser.email,
                        'text': masg,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurpleAccent),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(12.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
