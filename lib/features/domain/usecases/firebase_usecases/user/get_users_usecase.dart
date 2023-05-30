import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';

import '../../../repository/firebase_repository.dart';

class GetUserUseCase {
  final FirebaseRepository repository;

  GetUserUseCase({required this.repository});
  Stream<List<UserEntity>> call(UserEntity userEntity) {
    return repository.getUsers(userEntity);
  }
}
