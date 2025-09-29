import 'package:fluxfoot_user/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<void> call({required String email}) async {
    return await repository.sendPasswordResetEmail(email: email);
  }
}
