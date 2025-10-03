import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/auth/authwrapper.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/core/firebase/auth/firebase_auth_service.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/signin_bloc/signin_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
    final BaseAuthRepository authRepository = FirebaseAuthService(
      firebaseAuthInstance,
    );

    return MultiBlocProvider(
      providers: [
        RepositoryProvider<BaseAuthRepository>.value(value: authRepository),

        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(authRepository: authRepository),
        ),

        BlocProvider<SigninBloc>(
          create: (context) => SigninBloc(authRepository: authRepository),
        ),

        // BlocProvider<UserBloc>(
        //   create: (context) => UserBloc(authRepository: authRepository),
        // ),
      ],
      child: MaterialApp(
        title: 'FluxFoot_User',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Color(0xFFE0E0E0)),
        home: AuthWrapper(),
      ),
    );
  }
}
