import 'package:trace/components/my_bottom.dart';
import 'package:trace/components/my_textfield.dart';
import 'package:trace/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:trace/pages/pair.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {
    // print("Username: ${usernameController.text}");
    // print("Password: ${passwordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              controller: usernameController,
              hintText: 'Username',
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
              onTap: signUserIn,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PairPage()),
                      );
                    },
                    child: const Text("Click here",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
