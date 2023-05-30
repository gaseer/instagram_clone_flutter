import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'dart:io';
import '../../../repository/firebase_repository.dart';

class CreateUseCase {
  final FirebaseRepository repository;
  CreateUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}
