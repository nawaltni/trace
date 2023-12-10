import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/components/my_bottom.dart';
import 'package:trace/components/my_textfield.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';

class PairDeviceScreen extends ConsumerWidget {
  PairDeviceScreen({super.key});

  // text editing controllers
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
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
              MyBottom(
                  onTap: () => authRepository.pairDevice(codeController.text),
                  text: 'Pair Device')
            ]),
          ),
        ));
  }
}
