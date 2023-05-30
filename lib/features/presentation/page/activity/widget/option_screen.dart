import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('Mohammed Gaseer',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text('See the static vedios💙❤💛 ..',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                      ),
                      Text('Original Audio - some music track--',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(size: 30, color: Colors.white, Icons.favorite_outline),
                  Text(style: TextStyle(color: Colors.white), '601k'),
                  SizedBox(height: 30),
                  Icon(size: 30, color: Colors.white, Icons.comment_rounded),
                  Text(style: TextStyle(color: Colors.white), '1123'),
                  SizedBox(height: 30),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(size: 30, color: Colors.white, Icons.send),
                  ),
                  SizedBox(height: 50),
                  Icon(Icons.more_vert),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
