// // !!=============

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluxfoot_user/features/auth/domain/usecases/validator.dart';
// import 'package:fluxfoot_user/features/auth/presentation/cubit/signup_cubit.dart';
// import 'package:fluxfoot_user/features/auth/presentation/cubit/signup_state.dart';
// import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
// import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
// import 'package:fluxfoot_user/features/auth/presentation/screens/sign_in_screen.dart';
// import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';

// class SignUpScreen extends StatelessWidget {
//   SignUpScreen({super.key});

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     return BlocBuilder<FormValidatorCubit, FormValidatorState>(
//       builder: (context, state) {
//         const isLoading = false;
//         return Scaffold(
//           appBar: CustomAppBar(leading: customBackButton(context)),
//           body: Padding(
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
//                     autovalidateMode: state.autovalidateMode,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: height * 0.03),
//                         Text(
//                           'Sign Up',
//                           // Mocking GoogleFonts.openSans style
//                           style: TextStyle(
//                             fontSize: width * 0.09,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: height * 0.01),
//                         Text(
//                           "Please Register your account",
//                           // Mocking GoogleFonts.openSans style
//                           style: TextStyle(
//                             fontSize: width * 0.048,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: height * 0.04),
//                         // ! Name Input
//                         const NameInputField(),
//                         SizedBox(height: height * 0.02),
//                         // ! Email
//                         const EmailInputField(),
//                         SizedBox(height: height * 0.02),
//                         // ! Password
//                         const PasswordInputField(),
//                         SizedBox(height: height * 0.02),
//                         // ! Confirm Password
//                         const ConfirmPasswordInputField(),
//                         SizedBox(height: height * 0.02),
//                         // !Phone
//                         const PhoneInputField(),
//                         SizedBox(height: height * 0.03),
//                         // ! S I G N UP B U T T O N
//                         CustomButton(
//                           ontap: isLoading
//                               ? () {}
//                               : () {
//                                   // Validate the form
//                                   if (_formKey.currentState!.validate()) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                           'Form Validated! Proceeding to Sign Up...',
//                                         ),
//                                       ),
//                                     );
//                                     // If valid, navigate (mocked)
//                                     // context.read<FormValidatorCubit>().attemptSubmit(context); // Optional cubit method call
//                                     fadePUshReplaceMent(context, MainScreen());
//                                   } else {
//                                     // If invalid, enable AutovalidateMode.always to show errors
//                                     context
//                                         .read<FormValidatorCubit>()
//                                         .updateAutovalidateMode(
//                                           AutovalidateMode.always,
//                                         );
//                                   }
//                                 },
//                           text: isLoading ? 'Processing...' : 'Sign Up',
//                         ),
//                         SizedBox(height: height * 0.02),
//                         AuthCheckBox(
//                           mainAxis: MainAxisAlignment.center,
//                           prefText: 'Already have an account?.',
//                           sufWidget: TextButton(
//                             onPressed: () {
//                               fadePush(context, SignInScreen());
//                             },
//                             child: const Text(
//                               'Login',
//                               // Mocking GoogleFonts.openSans style
//                               style: TextStyle(
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
//           ),
//         );
//       },
//     );
//   }
// }

// //!--- INPUT FIELDS (Implement Cubit and Validator) ---

// class NameInputField extends StatelessWidget with Validator {
//   const NameInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<FormValidatorCubit>();
//     return BlocSelector<
//       FormValidatorCubit,
//       FormValidatorState,
//       AutovalidateMode
//     >(
//       selector: (state) => state.autovalidateMode,
//       builder: (context, autovalidateMode) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 5,
//           children: [
//             Text('Name'),
//             TextFormField(
//               autovalidateMode: autovalidateMode,
//               validator: validateName,
//               onChanged: cubit.updateName,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 hintText: 'Enter your name',
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class EmailInputField extends StatelessWidget with Validator {
//   const EmailInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<FormValidatorCubit>();
//     return BlocSelector<
//       FormValidatorCubit,
//       FormValidatorState,
//       AutovalidateMode
//     >(
//       selector: (state) => state.autovalidateMode,
//       builder: (context, autovalidateMode) {
//         return TextFormField(
//           autovalidateMode: autovalidateMode,
//           validator: validateEmail,
//           onChanged: cubit.updateEmail,
//           keyboardType: TextInputType.emailAddress,
//           decoration: const InputDecoration(
//             labelText: 'Email',
//             hintText: 'Enter your email',
//             prefixIcon: Icon(Icons.email),
//             border: OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class PasswordInputField extends StatelessWidget with Validator {
//   const PasswordInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<FormValidatorCubit>();
//     return BlocSelector<
//       FormValidatorCubit,
//       FormValidatorState,
//       Tuple2<bool, AutovalidateMode>
//     >(
//       selector: (state) => Tuple2(state.obscureText, state.autovalidateMode),
//       builder: (context, tuple) {
//         final obscureText = tuple.item1;
//         final autovalidateMode = tuple.item2;

//         return TextFormField(
//           autovalidateMode: autovalidateMode,
//           validator: validatePassword,
//           onChanged: cubit.updatePassword,
//           obscureText: obscureText,
//           keyboardType: TextInputType.visiblePassword,
//           decoration: InputDecoration(
//             labelText: 'Password',
//             hintText: 'Enter your password',
//             prefixIcon: const Icon(Icons.lock),
//             suffixIcon: IconButton(
//               onPressed: cubit.toggleObscureText,
//               icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//             ),
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class ConfirmPasswordInputField extends StatelessWidget with Validator {
//   const ConfirmPasswordInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<FormValidatorCubit>();
//     return BlocSelector<
//       FormValidatorCubit,
//       FormValidatorState,
//       Tuple<String, bool, AutovalidateMode>
//     >(
//       selector: (state) =>
//           Tuple(state.password, state.obscureText, state.autovalidateMode),
//       builder: (context, tuple) {
//         final password = tuple.item1;
//         final obscureText = tuple.item2;
//         final autovalidateMode = tuple.item3;

//         return TextFormField(
//           autovalidateMode: autovalidateMode,
//           validator: (value) => validateConfirmPassword(value, password),
//           onChanged: cubit.updateConfirmPassword,
//           obscureText: obscureText,
//           keyboardType: TextInputType.visiblePassword,
//           decoration: const InputDecoration(
//             labelText: 'Confirm password',
//             hintText: 'Re-enter your password',
//             prefixIcon: Icon(Icons.lock_reset),
//             border: OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class PhoneInputField extends StatelessWidget with Validator {
//   const PhoneInputField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<FormValidatorCubit>();
//     return BlocSelector<
//       FormValidatorCubit,
//       FormValidatorState,
//       AutovalidateMode
//     >(
//       selector: (state) => state.autovalidateMode,
//       builder: (context, autovalidateMode) {
//         return TextFormField(
//           autovalidateMode: autovalidateMode,
//           validator: validatePhone,
//           onChanged: cubit.updatePhone,
//           keyboardType: TextInputType.phone,
//           decoration: const InputDecoration(
//             labelText: 'Phone',
//             hintText: 'Enter your phone number (10 digits)',
//             prefixIcon: Icon(Icons.phone),
//             border: OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// // Simple Tuple class for BlocSelector with multiple values
// class Tuple<T1, T2, T3> {
//   final T1 item1;
//   final T2 item2;
//   final T3 item3;
//   const Tuple(this.item1, this.item2, this.item3);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Tuple &&
//           runtimeType == other.runtimeType &&
//           item1 == other.item1 &&
//           item2 == other.item2 &&
//           item3 == other.item3;
//   @override
//   int get hashCode => item1.hashCode ^ item2.hashCode ^ item3.hashCode;
// }

// class Tuple2<T1, T2> {
//   final T1 item1;
//   final T2 item2;
//   const Tuple2(this.item1, this.item2);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Tuple2 &&
//           runtimeType == other.runtimeType &&
//           item1 == other.item1 &&
//           item2 == other.item2;
//   @override
//   int get hashCode => item1.hashCode ^ item2.hashCode;
// }
