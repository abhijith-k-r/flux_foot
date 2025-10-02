// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluxfoot_user/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:fluxfoot_user/features/auth/presentation/bloc/auth_event.dart';
// import 'package:fluxfoot_user/features/auth/presentation/widgets/form_validators.dart';
// import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
// import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
// import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _phoneController = TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     return Scaffold(
//       appBar: CustomAppBar(leading: customBackButton(context)),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthEroor) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is SignUpSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             fadePush(context, MainScreen());
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: width * 0.04,
//               vertical: height * 0.02,
//             ),
//             child: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight:
//                       height -
//                       kToolbarHeight -
//                       MediaQuery.of(context).padding.top,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       children: [
//                         SizedBox(height: height * 0.03),
//                         Text(
//                           'Sign Up',
//                           style: GoogleFonts.openSans(
//                             fontSize: width * 0.09,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: height * 0.01),
//                         Text(
//                           "Please Register your account",
//                           style: GoogleFonts.openSans(
//                             fontSize: width * 0.048,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: height * 0.04),
//                         CustomTextFormField(
//                           label: 'Full Name',
//                           hintText: 'Enter Name...',
//                           controller: _nameController,
//                           validator: FormValidators.validateName,
//                           prefIcon: Padding(
//                             padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
//                             child: FaIcon(FontAwesomeIcons.user, size: 20),
//                           ),
//                         ),
//                         SizedBox(height: height * 0.02),
//                         CustomTextFormField(
//                           label: 'E-mail Address',
//                           hintText: 'Enter Email...',
//                           controller: _emailController,
//                           validator: FormValidators.validateEmail,
//                           prefIcon: Padding(
//                             padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
//                             child: FaIcon(FontAwesomeIcons.envelope, size: 20),
//                           ),
//                         ),
//                         SizedBox(height: height * 0.02),
//                         CustomTextFormField(
//                           label: 'Password',
//                           hintText: 'create Password...',
//                           controller: _passwordController,
//                           validator: FormValidators.validatePassword,
//                           prefIcon: Icon(Icons.lock_outline_rounded),
//                           sufIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                           obscureText: !_isPasswordVisible,
//                         ),
//                         SizedBox(height: height * 0.02),
//                         CustomTextFormField(
//                           label: 'Password',
//                           hintText: 'confirm Password...',
//                           controller: _confirmPasswordController,
//                           prefIcon: Icon(Icons.lock_outline_rounded),
//                           validator: (value) =>
//                               FormValidators.validateConfirmPassword(
//                                 _passwordController.text,
//                                 value,
//                               ),
//                           obscureText: !_isConfirmPasswordVisible,

//                           sufIcon: IconButton(
//                             icon: Icon(
//                               _isConfirmPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isConfirmPasswordVisible =
//                                     !_isConfirmPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),

//                         SizedBox(height: height * 0.02),
//                         CustomTextFormField(
//                           label: 'Phone Number',
//                           hintText: '+91 (0000000000)',
//                           controller: _phoneController,
//                           validator: FormValidators.validatePhone,
//                           prefIcon: Padding(
//                             padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
//                             child: FaIcon(FontAwesomeIcons.person, size: 20),
//                           ),
//                         ),

//                         // SizedBox(height: height * 0.01),
//                         SizedBox(height: height * 0.03),
//                         // ! S I G N UP B U T T O N
//                         CustomButton(
//                           ontap: state is AuthLoading
//                               ? null
//                               : () {
//                                   if (_formKey.currentState!.validate()) {
//                                     context.read<AuthBloc>().add(
//                                       SignUpRequested(
//                                         name: _nameController.text.trim(),
//                                         email: _emailController.text.trim(),
//                                         password: _passwordController.text,
//                                         phone: _phoneController.text.trim(),
//                                       ),
//                                     );
//                                   }
//                                 },
//                           widget: state is AuthLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : null,
//                           text: 'Sign Up',
//                         ),
//                         SizedBox(height: height * 0.02),
//                         AuthCheckBox(
//                           mainAxis: MainAxisAlignment.center,
//                           prefText: 'Already have an account?.',
//                           sufWidget: TextButton(
//                             onPressed: () {
//                               fadePush(context, LoginScreen());
//                             },
//                             child: Text(
//                               'Login',
//                               style: GoogleFonts.openSans(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFFF8C00),
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(height: height * 0.02),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
