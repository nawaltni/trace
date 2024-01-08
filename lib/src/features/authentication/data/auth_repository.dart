import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trace/domain/auth.dart';
import 'package:trace/domain/profile.dart';
import 'package:trace/src/grpc/auth.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  // constructor
  AuthRepository(this._firebaseAuth, this._nawaltAuth);
  // declare private variable
  final FirebaseAuth _firebaseAuth;
  final NawaltAuthAPI _nawaltAuth;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserProfile? profile;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign in using Firebase with email and password
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

    String? bearer;
    try {
      bearer = await _firebaseAuth.currentUser!.getIdToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        print('The custom token has expired.');
      }
    }

    // get profile using the firebase jwt token
    try {
      profile = await _nawaltAuth.getProfile(bearer);
      print('Profile: $profile');
      final prefs = await _prefs;
      await prefs.setString("user_id", profile!.id);
      await prefs.setString("user_name", profile!.name);
      await prefs.setString("user_email", profile!.email);
    } on GrpcError catch (e) {
      print('Getting profile failed with code ${e.code}: ${e.message}');
    }
  }

  /// Pair device using a code with Nawalt auth service
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
      } else {
        print('Unknown error');
      }
    }

    String? bearer;
    try {
      bearer = await _firebaseAuth.currentUser!.getIdToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        print('The custom token has expired.');
      }
    }

    // get profile using the firebase jwt token
    try {
      profile = await _nawaltAuth.getProfile(bearer);
      print('Profile: $profile');

      await saveProfile(profile!);
    } on GrpcError catch (e) {
      print('Getting profile failed with code ${e.code}: ${e.message}');
    }
  }

  /// Get the current user profile
  Future<UserProfile?> getCurrentProfile() async {
    final storedProfile = await getPersistedProfile();
    if (storedProfile != null) {
      print("Found stored profile");
      return storedProfile;
    }

    String? bearer;
    try {
      bearer = await _firebaseAuth.currentUser!.getIdToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        print('The custom token has expired.');
        return null;
      }
    }

    try {
      profile = await _nawaltAuth.getProfile(bearer);
    } on GrpcError catch (e) {
      print('Getting profile failed with code ${e.code}: ${e.message}');
      return null;
    }

    return profile;
  }

  /// Save the current user profile to shared preferences
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await _prefs;

    await prefs.setString("user_id", profile.id);
    await prefs.setString("user_name", profile.name);
    await prefs.setString("user_email", profile.email);
    await prefs.setString("user_phone", profile.phone);
    await prefs.setString("user_address", profile.address);
    await prefs.setString("user_city", profile.city);
    await prefs.setString("user_state", profile.state);
  }

  /// Delete the current user profile from shared preferences
  Future<void> deleteProfile() async {
    final prefs = await _prefs;

    await prefs.remove("user_id");
    await prefs.remove("user_name");
    await prefs.remove("user_email");
    await prefs.remove("user_phone");
    await prefs.remove("user_address");
    await prefs.remove("user_city");
    await prefs.remove("user_state");
  }

  /// get the current user profile from shared preferences
  Future<UserProfile?> getPersistedProfile() async {
    print("Getting stored profile");
    final prefs = await _prefs;
    final userId = prefs.getString("user_id") ?? "";
    final userName = prefs.getString("user_name") ?? "";
    final userEmail = prefs.getString("user_email") ?? "";
    final userPhone = prefs.getString("user_phone") ?? "";
    final userAddress = prefs.getString("user_address") ?? "";
    final userCity = prefs.getString("user_city") ?? "";
    final userState = prefs.getString("user_state") ?? "";

    if (userId == "") {
      return null;
    }

    return UserProfile(
        id: userId,
        name: userName,
        email: userEmail,
        phone: userPhone,
        address: userAddress,
        city: userCity,
        state: userState);
  }

  Future<AuthData> getAuthData() async {
    final prefs = await _prefs;
    final userId = prefs.getString("user_id") ?? "";
    final bearer = await _firebaseAuth.currentUser!.getIdToken();

    return AuthData(userId: userId, token: bearer!);
  }

  Future<void> signOut() async {
    print('Signing out.');
    await _firebaseAuth.signOut();
    await deleteProfile();
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

// CurrentUser Provider returns the current user. This is used to determine
// if the user is logged in or not.
@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(authRepositoryProvider).currentUser;
}

@riverpod
Future<UserProfile?> currentProfile(CurrentProfileRef ref) async {
  return ref.watch(authRepositoryProvider).getCurrentProfile();
}
