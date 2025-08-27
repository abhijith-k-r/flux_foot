import 'package:flutter/material.dart';
import 'package:fluxfoot_user/presentaion/screens/splash_screen.dart';

void main() {
  runApp(MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluxFoot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFE0E0E0)),
      home: SplashScreen(),
    );
  }
}
