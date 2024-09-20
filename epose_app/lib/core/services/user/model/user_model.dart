class UserModel {
  final String uid;
  String password;
  String email;
  UserModel({
    required this.uid,
    required this.password,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      password: json['password'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'password': password,
      'email': email,
    };
  }
}