import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:focus_craftz_application/core/error/exceptions.dart';
import 'package:focus_craftz_application/features/profile/data/models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String uid);
  Future<UserProfileModel> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  UserProfileRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserProfileModel> getUserProfile(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw const ServerException('User profile not found');
      }
      return UserProfileModel.fromMap(doc.data()!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final model = UserProfileModel.newUser(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
      await _users.doc(uid).set(model.toMap());
      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
