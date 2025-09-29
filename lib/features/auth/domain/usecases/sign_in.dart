import 'package:fluxfoot_user/features/auth/domain/entities/user.dart';
import 'package:fluxfoot_user/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<User> call({required String email, required String password}) async {
    return await repository.signIn(email: email, password: password);
  }
}
