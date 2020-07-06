class User {
  final String uid;
  final String email;

  User({this.uid, this.email});

  factory User.fromMap(Map<dynamic, dynamic> value) {
    return User(uid: value["uid"], email: value["email"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'uid': uid, 'email': email};
  }
}
