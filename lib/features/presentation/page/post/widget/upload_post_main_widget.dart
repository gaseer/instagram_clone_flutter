import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/features/presentation/page/profile/widget/profile_form_widget.dart';
import 'package:instagram_clone/profile_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  TextEditingController _descriptionController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    final List<Widget> imageWidgets = [
      GestureDetector(
        child: Image.asset(
          'assets/3d-camera.png',
          width: 100.0,
          height: 100.0,
        ),
        onTap: () {
          _getImage(ImageSource.camera);
          Navigator.pop(context); // Add this line to close the bottom sheet
        },
      ),
      GestureDetector(
        child: Image.asset(
          'assets/gallery.png',
          width: 100.0,
          height: 100.0,
        ),
        onTap: () {
          _getImage(ImageSource.gallery);
          Navigator.pop(context); // Add this line to close the bottom sheet
        },
      ),
    ];

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 200,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: imageWidgets,
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().getImage(source: source);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No image has been selected");
        }
      });
    } catch (e) {
      toast("Some error occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? _uploadPostWidget()
        : Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              backgroundColor: backGroundColor,
              leading: GestureDetector(
                  onTap: () => setState(() => _image = null),
                  child: Icon(
                    Icons.close,
                    size: 28,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: _submitPost, child: Icon(Icons.arrow_forward)),
                )
              ],
            ),
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: constraints.maxHeight * 0.1,
                          height: constraints.maxHeight * 0.1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: profileWidget(
                                imageUrl: "${widget.currentUser.profileUrl}"),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${widget.currentUser.username}",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: constraints.maxHeight *
                              0.7, // Adjust the height dynamically
                          child: profileWidget(image: _image),
                        ),
                        SizedBox(height: 10),
                        _uploading == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Uploading...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 10),
                                  CircularProgressIndicator(),
                                ],
                              )
                            : ProfileFormWidget(
                                title: "Description",
                                controller: _descriptionController,
                              ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    di
        .sl<UploadImageToStorageUseCase>()
        .call(_image!, true, "posts")
        .then((imageUrl) {
      _createSubmitPost(image: imageUrl);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
                description: _descriptionController.text,
                createAt: Timestamp.now(),
                creatorUid: widget.currentUser.uid,
                likes: [],
                postId: Uuid().v1(),
                postImageUrl: image,
                totalComments: 0,
                totalLikes: 0,
                username: widget.currentUser.username,
                userProfileUrl: widget.currentUser.profileUrl))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _uploading = false;
      _descriptionController.clear();
      _image = null;
    });
  }

  _uploadPostWidget() {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: GestureDetector(
          onTap: selectImage,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.upload,
                color: primaryColor,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
