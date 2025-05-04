import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? fullName;
  String? userName;
  String? email;
  String? dateOfBirth;
  String? gender;
  bool? isOnboarding;
  String? currentLevel;
  String? preferredLanguage;

  User({
    this.fullName,
    this.userName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.isOnboarding,
    this.currentLevel,
    this.preferredLanguage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'isOnboarding': isOnboarding,
      'currentLevel': currentLevel,
      'preferredLanguage': preferredLanguage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      dateOfBirth:
          map['dateOfBirth'] != null ? map['dateOfBirth'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      isOnboarding:
          map['isOnboarding'] != null ? map['isOnboarding'] as bool : null,
      currentLevel:
          map['currentLevel'] != null ? map['currentLevel'] as String : null,
      preferredLanguage: map['preferredLanguage'] != null
          ? map['preferredLanguage'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
