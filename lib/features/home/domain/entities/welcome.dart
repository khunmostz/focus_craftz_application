import 'package:equatable/equatable.dart';

class Welcome extends Equatable {
  const Welcome({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
