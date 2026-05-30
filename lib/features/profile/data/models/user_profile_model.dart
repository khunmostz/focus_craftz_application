import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.coins,
    required this.xp,
    required this.level,
    required this.streak,
    this.lastFocusDate,
    required this.totalFocusMinutes,
    required this.weeklyFocusMinutes,
    required this.weekStartDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      level: (map['level'] as num?)?.toInt() ?? 1,
      streak: (map['streak'] as num?)?.toInt() ?? 0,
      lastFocusDate: (map['lastFocusDate'] as Timestamp?)?.toDate(),
      totalFocusMinutes: (map['totalFocusMinutes'] as num?)?.toInt() ?? 0,
      weeklyFocusMinutes: (map['weeklyFocusMinutes'] as num?)?.toInt() ?? 0,
      weekStartDate: (map['weekStartDate'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory UserProfileModel.newUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    // week starts on Monday
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartNormalized =
        DateTime(weekStart.year, weekStart.month, weekStart.day);
    return UserProfileModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      coins: 0,
      xp: 0,
      level: 1,
      streak: 0,
      lastFocusDate: null,
      totalFocusMinutes: 0,
      weeklyFocusMinutes: 0,
      weekStartDate: weekStartNormalized,
      createdAt: now,
      updatedAt: now,
    );
  }

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int coins;
  final int xp;
  final int level;
  final int streak;
  final DateTime? lastFocusDate;
  final int totalFocusMinutes;
  final int weeklyFocusMinutes;
  final DateTime weekStartDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'coins': coins,
        'xp': xp,
        'level': level,
        'streak': streak,
        'lastFocusDate':
            lastFocusDate != null ? Timestamp.fromDate(lastFocusDate!) : null,
        'totalFocusMinutes': totalFocusMinutes,
        'weeklyFocusMinutes': weeklyFocusMinutes,
        'weekStartDate': Timestamp.fromDate(weekStartDate),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  UserProfile toEntity() => UserProfile(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        coins: coins,
        xp: xp,
        level: level,
        streak: streak,
        lastFocusDate: lastFocusDate,
        totalFocusMinutes: totalFocusMinutes,
        weeklyFocusMinutes: weeklyFocusMinutes,
        weekStartDate: weekStartDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
