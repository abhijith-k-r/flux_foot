
import 'package:fluxfoot_user/features/auth/domain/entities/user.dart';
import 'package:fluxfoot_user/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<User> call() async {
    return await repository.signInWithGoogle();
  }
}
