class UserType {
  final String type;
  final String uid;
  UserType({
    this.type,
    this.uid,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      type: json['type'],
      uid: json['uid'],
    );
  }
}
