import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final String? studentid;
  late final String? fullName;
  late final String? email;
  final String? password;
  late final String? gender;
  late final String? level;
  String? profilePicture;

  Users(
      {this.studentid,
      this.fullName,
      this.email,
      this.password,
      this.gender,
      this.level,
      this.profilePicture});


  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      studentid: map['studentid'].toString(), // Convert int to String
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      level: map['level'],
      profilePicture: map['profilePicture'],
    );
  }

  Map<String, dynamic> toMap() => {
        "studentid": studentid,
        "fullName": fullName,
        "email": email,
        "password": password,
        "gender": gender,
        "level": level,
        "profilePicture": profilePicture,
      };
}