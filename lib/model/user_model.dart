class UserModel {
  final String name;
  final String uid;
  final String email;
  final String birthdate;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.name,
    required this.uid,
    required this.email,
    required this.birthdate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid &&
          email == other.email &&
          birthdate == other.birthdate);

  @override
  int get hashCode => name.hashCode ^ uid.hashCode ^ email.hashCode ^ birthdate.hashCode;

  @override
  String toString() {
    return 'UserModel{ name: $name, uid: $uid, email: $email, birthdate: $birthdate,}';
  }

  UserModel copyWith({
    String? name,
    String? uid,
    String? email,
    String? birthdate,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'uid': this.uid,
      'email': this.email,
      'birthdate': this.birthdate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      birthdate: map['birthdate'] as String,
    );
  }

//</editor-fold>
}