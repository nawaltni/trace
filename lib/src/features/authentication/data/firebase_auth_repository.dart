import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  // constructor
  AuthRepository(this._auth);
  // declare private variable
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    print('Signing in with email and password.');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    print('Signing out.');
    await _auth.signOut();
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
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

// AuthStateChanges Provider returns a stream of User. This is used to determine
// if the user is logged in or not.
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
