// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:trace/pages/dashboard.dart';
// import 'package:trace/pages/login.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // attempting to login
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//             // user is logged in
//           } else if (snapshot.hasData) {
//             return const DashboardPage();
//           } else {
//             // user is not logged in
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
