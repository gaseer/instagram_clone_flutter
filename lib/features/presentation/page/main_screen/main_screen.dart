import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/constants.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:instagram_clone/features/presentation/page/activity/activity_page.dart';
import 'package:instagram_clone/features/presentation/page/home/home_screen.dart';
import 'package:instagram_clone/features/presentation/page/post/upload_post_page.dart';
import 'package:instagram_clone/features/presentation/page/profile/profile_page.dart';
import 'package:instagram_clone/features/presentation/page/search/search_page.dart';

import '../../cubit/user/get_single_user/get_single_user_cubit.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            backgroundColor: backGroundColor,
            bottomNavigationBar: CupertinoTabBar(
              currentIndex: _currentIndex,
              backgroundColor: backGroundColor,
              onTap: navigationTapped,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _currentIndex == 0
                            ? 'assets/vectors/home-bold.svg'
                            : 'assets/vectors/home-outline.svg',
                        color: Colors.white),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _currentIndex == 1
                            ? 'assets/vectors/search-bold.svg'
                            : 'assets/vectors/search-outline.svg',
                        color: Colors.white),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _currentIndex == 2
                            ? 'assets/vectors/add-square-bold.svg'
                            : 'assets/vectors/add-square-outline.svg',
                        color: Colors.white),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _currentIndex == 3
                            ? 'assets/vectors/video-play-bold.svg'
                            : 'assets/vectors/video-play-outline.svg',
                        color: Colors.white),
                    label: ''),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: _currentIndex == 4
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: currentUser.profileUrl != null &&
                            currentUser.profileUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              currentUser.profileUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            size: 25,
                            Icons.person,
                            color: Colors.white,
                          ),
                  ),
                  label: '',
                ),
              ],
            ),
            body: PageView(
              controller: pageController,
              children: [
                HomePage(),
                SearchPage(),
                UploadPostPage(currentUser: currentUser),
                ActivityPage(),
                ProfilePage(currentUser: currentUser)
              ],
              onPageChanged: onPageChanged,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
