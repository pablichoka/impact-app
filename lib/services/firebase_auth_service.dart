import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // placeholder: insert SHA-1 / SHA-256 fingerprint info in project documentation if needed for google sign-in

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signUpEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user;
    if (user != null) {
      await _createUserDocIfNeeded(user);
      await user.sendEmailVerification();
    }
    return cred;
  }

  Future<UserCredential> signInEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _updateLoginMetadata(cred.user);
    return cred;
  }

  Future<void> sendPasswordReset(String email) => _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> signInGoogle() async {
    // google sign-in flow with debug logging
    try {
      // sign out any previous session to avoid stale account issues
      final google = GoogleSignIn();
      final current = await google.signInSilently();
      if (current != null) {
        await google.disconnect();
      }
      final account = await google.signIn();
      if (account == null) {
        throw Exception('cancelled');
      }
      final auth = await account.authentication;
      if (auth.idToken == null) {
        throw Exception('missing idToken');
      }
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);
      final cred = await _auth.signInWithCredential(credential);
      await _postSocialLogin(cred.user, provider: 'google');
      return cred;
    } catch (e) {
      // rethrow so caller can surface message
      throw Exception('google_sign_in_error: $e');
    }
  }

  Future<void> signInMicrosoftPlaceholder() async {
    // placeholder: implement microsoft oauth (msal or custom redirect) later
    throw Exception('microsoft provider not implemented');
  }

  Future<void> _createUserDocIfNeeded(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) return;
    await ref.set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'emailVerified': user.emailVerified,
      'providerIds': user.providerData.map((p) => p.providerId).toList(),
      'roles': ['user'],
    });
  }

  Future<void> _updateLoginMetadata(User? user) async {
    if (user == null) return;
    final ref = _db.collection('users').doc(user.uid);
    await ref.set({
      'lastLoginAt': FieldValue.serverTimestamp(),
      'emailVerified': user.emailVerified,
    }, SetOptions(merge: true));
  }

  Future<void> _postSocialLogin(User? user, {required String provider}) async {
    if (user == null) return;
    await _createUserDocIfNeeded(user);
    await _updateLoginMetadata(user);
    final ref = _db.collection('users').doc(user.uid);
    await ref.set({'lastProvider': provider}, SetOptions(merge: true));
  }
}
