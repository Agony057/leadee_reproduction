class UserModel {
  late final String email;
  late final String password;
  late String? uid;

  UserModel({
    this.email = "",
    this.password = "",
    this.uid,
  });

  set setUid(value) => uid = value;

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "password": password,
      };
}
