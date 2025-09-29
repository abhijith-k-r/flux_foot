import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/auth/authwrapper.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxfoot_user/firebase_options.dart';
import 'package:fluxfoot_user/injectiontion_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
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
