import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/components/my_bottom.dart';
import 'package:trace/components/my_textfield.dart';
import 'package:trace/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:trace/src/routing/app_router.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 50),
              // Logo
              const Icon(Icons.lock, size: 100),
              const SizedBox(height: 50),

              // Welcome back
              Text("Welcome Back!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700])),

              const SizedBox(height: 25),
              //username textield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 25),
              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // sign in button
              MyBottom(
                onTap: () => authRepository.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text),
                text: 'Sign In',
              ),
              const SizedBox(height: 25),
              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("Or continue with",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600])),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 25),
              // google + facebook sign in button
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/google.png'),
                  SizedBox(width: 20),
                  SquareTile(imagePath: 'lib/images/facebook.png'),
                ],
              ),
              const SizedBox(height: 50),
              // Pairing Device? click here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Pairing Device? ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => ref.read(goRouterProvider).go('/pairDevice'),
                      child: const Text("Click here",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
