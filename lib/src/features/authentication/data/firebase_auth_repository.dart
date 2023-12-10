import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trace/src/grpc/auth.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  // constructor
  AuthRepository(this._firebaseAuth, this._nawaltAuth);
  // declare private variable
  final FirebaseAuth _firebaseAuth;
  final NawaltAuthAPI _nawaltAuth;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    print('Signing in with email and password.');
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> pairDevice(String code) async {
    print('Pairing device.');

    // We call our GRPC based API here to pair the device
    // It will return a token that we will use to sign in with custom token
    // in firebase.

    String token;

    try {
      token = await _nawaltAuth.pairDevice(code);
    } on GrpcError catch (e) {
      print('Pairing device failed with code ${e.code}: ${e.message}');
      return;
    }

    try {
      await _firebaseAuth.signInWithCustomToken(token);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-custom-token') {
        print(
            'The custom token format is incorrect. Please check the documentation.');
      } else if (e.code == 'custom-token-mismatch') {
        print('The custom token corresponds to a different audience.');
      }
    }
  }

  Future<void> signOut() async {
    print('Signing out.');
    await _firebaseAuth.signOut();
  }
}

// FirebaseAuth Provider
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

// AuthRepository Provider
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // firebaseAuth is injected into the AuthRepository constructor
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(nawaltAuthAPIProvider),
  );
}

// AuthStateChanges Provider returns a stream of User. This is used to determine
// if the user is logged in or not.
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
