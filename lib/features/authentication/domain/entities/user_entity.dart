import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime lastLogin;

  const UserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePhoto,
    required this.createdAt,
    required this.lastLogin,
  });

  @override
  List<Object?> get props => [
        uid,
        fullName,
        email,
        phoneNumber,
        profilePhoto,
        createdAt,
        lastLogin,
      ];
}
