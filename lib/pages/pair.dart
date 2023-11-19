import 'package:flutter/material.dart';
import 'package:trace/components/my_bottom.dart';
import 'package:trace/components/my_textfield.dart';

class PairPage extends StatelessWidget {
  PairPage({super.key});

  // text editing controllers
  final codeController = TextEditingController();

  // pair device method
  void pairDevice() {
    // print("Code: ${codeController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Pair Device',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              MyTextField(
                  controller: codeController,
                  hintText: 'digit code',
                  obscureText: false),
              const SizedBox(height: 25),
              MyBottom(onTap: pairDevice, text: 'Pair Device')
            ]),
          ),
        ));
  }
}
