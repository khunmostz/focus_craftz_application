import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
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

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        coins,
        xp,
        level,
        streak,
        lastFocusDate,
        totalFocusMinutes,
        weeklyFocusMinutes,
        weekStartDate,
        createdAt,
        updatedAt,
      ];
}
