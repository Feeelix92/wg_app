class UserModel {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String birthdate;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.uid,
    required this.email,
    required this.birthdate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          uid == other.uid &&
          email == other.email &&
          birthdate == other.birthdate);

  @override
  int get hashCode =>
      username.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      uid.hashCode ^
      email.hashCode ^
      birthdate.hashCode;

  @override
  String toString() {
    return 'UserModel{ username: $username, firstName: $firstName, lastName: $lastName, uid: $uid, email: $email, birthdate: $birthdate,}';
  }

  UserModel copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? uid,
    String? email,
    String? birthdate,
  }) {
    return UserModel(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'uid': uid,
      'email': email,
      'birthdate': birthdate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      birthdate: map['birthdate'] as String,
    );
  }

//</editor-fold>
}