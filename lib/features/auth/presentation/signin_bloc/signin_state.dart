part of 'signin_bloc.dart';

class SigninState extends Equatable {
  final AutovalidateMode autovalidateMode;
  final String email;
  final String password;
  final String? errorMessage;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isSuccess;

  const SigninState({
    this.autovalidateMode = AutovalidateMode.disabled,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
  });

  SigninState copyWith({
    AutovalidateMode? autovalidateMode,
    String? email,
    String? password,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isSuccess,

  }) {
    return SigninState(
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object> get props => [autovalidateMode, email, password,?errorMessage,isPasswordVisible,isLoading,isSuccess];
}
