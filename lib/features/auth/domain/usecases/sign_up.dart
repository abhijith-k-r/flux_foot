import 'package:fluxfoot_user/features/auth/domain/entities/user.dart';
import 'package:fluxfoot_user/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await repository.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
