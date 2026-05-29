import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:focus_craftz_application/core/error/exceptions.dart';
import 'package:focus_craftz_application/features/auth/data/models/user_model.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn, this._firestore);

  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  @override
  Stream<AuthUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(credential.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorCode(e.code));
    } catch (_) {
      throw const AuthException('An unexpected error occurred.');
    }
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUser(credential.user)!;
      await _saveUserToFirestore(user);
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorCode(e.code));
    } catch (_) {
      throw const AuthException('An unexpected error occurred.');
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AuthException('Google Sign-In cancelled.');

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = _mapFirebaseUser(userCredential.user)!;

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _saveUserToFirestore(user);
      }

      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorCode(e.code));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Google Sign-In failed. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw const AuthException('Failed to sign out.');
    }
  }

  Future<void> _saveUserToFirestore(AuthUser user) async {
    try {
      final model = UserModel.fromAuthUser(user);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(model.toMap(), SetOptions(merge: false));
    } catch (_) {
      // Firestore write failure is non-fatal — auth already succeeded.
      // Profile will be re-created defensively on first read.
    }
  }

  AuthUser? _mapFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  String _mapFirebaseErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
