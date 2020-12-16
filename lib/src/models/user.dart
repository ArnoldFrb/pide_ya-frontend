class User {
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String password;
  final String photoURL;
  final String direction;

  User({this.uid, this.displayName, this.email, this.phoneNumber, this.password, this.photoURL, this.direction});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      photoURL: json['photoURL'],
      direction: json['direction'],
    );
  }
}