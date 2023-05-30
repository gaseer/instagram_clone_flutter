import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/features/presentation/page/home/widgets/single_post_card_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../chat/chat_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: backGroundColor,
            title: SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 32,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  size: 30,
                  Icons.favorite_border_rounded,
                  color: primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  size: 30,
                  MaterialCommunityIcons.facebook_messenger,
                  color: primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
              ),
              SizedBox(
                width: 10,
              )
            ],
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final users = snapshot.data!.docs;
                      return Row(
                        children: List.generate(users.length, (index) {
                          final user = users[index];
                          final username = user['username'];
                          final profileUrl = user['profileUrl'];

                          return Padding(
                            padding: EdgeInsets.all(7),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.pink,
                                      width: 3,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: ClipOval(
                                      child: profileUrl != null &&
                                              profileUrl.isNotEmpty
                                          ? Image.network(
                                              profileUrl,
                                              height: 68,
                                              width: 68,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                if (progress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              "assets/profile_default.png",
                                              height: 68,
                                              width: 68,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.5),
                                Flexible(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: .5),
                                    child: Text(
                                      username,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }
                    return Center(
                        child:
                            CircularProgressIndicator()); // Display a centered CircularProgressIndicator if no data is available
                  },
                ),
              ),
            ),
          ),
          BlocProvider<PostCubit>(
            create: (context) =>
                di.sl<PostCubit>()..getPosts(post: PostEntity()),
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, postState) {
                if (postState is PostLoading) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (postState is PostFailure) {
                  toast("Some Failure occurred while creating the post");
                }
                if (postState is PostLoaded) {
                  final posts = postState.posts;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        return BlocProvider(
                          create: (context) => di.sl<PostCubit>(),
                          child: SinglePostCardWidget(post: post),
                        );
                      },
                      childCount: posts.length,
                    ),
                  );
                }
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _noPostsYetWidget() {
    return Center(
      child: Text(
        "No Posts Yet",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
