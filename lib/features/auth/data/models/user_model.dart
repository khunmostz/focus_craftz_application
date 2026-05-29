import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.coins = 0,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
  });

  factory UserModel.fromAuthUser(AuthUser user) => UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int coins;
  final int xp;
  final int level;
  final int streak;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'coins': coins,
        'xp': xp,
        'level': level,
        'streak': streak,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
