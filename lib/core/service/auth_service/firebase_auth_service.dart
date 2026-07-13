import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Open Google account picker
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      // User cancelled
      if (googleUser == null) {
        return null;
      }

      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create Firebase credential
      final AuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");
      print(e.message);
      return null;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Current User
  User? get currentUser => _auth.currentUser;

  /// Check Login
  bool get isLoggedIn => _auth.currentUser != null;
}