// import 'package:get_it/get_it.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart'; 


// import 'features/auth/data/repositories/auth_repository_impl.dart';
// import 'features/auth/domain/repositories/auth_repository.dart';
// import 'features/auth/domain/usecases/sign_up.dart';
// import 'features/auth/domain/usecases/sign_in.dart';
// import 'features/auth/domain/usecases/google_sign_in.dart';
// import 'features/auth/domain/usecases/forgot_password.dart';
// import 'features/auth/presentation/bloc/auth_bloc.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   //! Features - Authentication
//   // Bloc
//   sl.registerFactory(
//     () => AuthBloc(
//       signUp: sl(),
//       signIn: sl(),
//       googleSignIn: sl(),
//       forgotPassword: sl(),
//       authRepository: sl(),
//     ),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => SignUp(sl()));
//   sl.registerLazySingleton(() => SignIn(sl()));
//   sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
//   sl.registerLazySingleton(() => ForgotPassword(sl()));

//   // Repository
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       firebaseAuth: sl(),
//       firestore: sl(),
//       googleSignIn: sl(),
//     ),
//   );

//   //! External
//   sl.registerLazySingleton(() => FirebaseAuth.instance);
//   sl.registerLazySingleton(() => FirebaseFirestore.instance);
//   sl.registerLazySingleton(() => GoogleSignIn.instance);
// }
