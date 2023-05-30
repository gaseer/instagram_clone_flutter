import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({required this.sen, required this.ms, required this.isMe});
  final String? sen;
  final String? ms;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sen",
            style: TextStyle(fontSize: 12.0, color: Colors.white),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 15.0,
            color: isMe ? Colors.deepPurpleAccent : Colors.white10,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                '$ms',
                style: isMe
                    ? TextStyle(fontSize: 20.0, color: Colors.white)
                    : TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
