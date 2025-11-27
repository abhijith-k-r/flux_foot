import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/services/auth/authwrapper.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/services/firebase/cart_repository.dart';
import 'package:fluxfoot_user/core/services/firebase/favorites_repository.dart';
import 'package:fluxfoot_user/core/services/firebase/user_product_repository.dart';
import 'package:fluxfoot_user/features/auth/view_model/firebase/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/view_model/firebase/firebase_auth_service.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/signin_bloc/signin_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/wishlists/view_model/bloc/favorites_bloc.dart';
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
    final productRepository = UserProductRepository();
    final favoritesRepository = FavoritesRepository();
    final cartRepository = CartRepository();
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

        BlocProvider<HomeBloc>(
          create: (context) {
            final bloc = HomeBloc(productRepository);
            bloc.add(LoadFeaturedProducts());
            bloc.add(LoadBrands());
            return bloc;
          },
        ),

        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(repo: favoritesRepository),
        ),

        BlocProvider<FilterBloc>(create: (context) => FilterBloc()),

        BlocProvider<CartBloc>(create: (context) => CartBloc(repo: cartRepository)),
      ],
      child: MaterialApp(
        title: 'FluxFoot_User',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppColors.scaffBg),
        home: AuthWrapper(),
      ),
    );
  }
}
