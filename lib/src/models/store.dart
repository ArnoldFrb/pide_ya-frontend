class Store {
  final String displayName;
  final String phoneNumber;
  final String photoURL;
  final String direction;
  final String type;
  final String uid;

  Store({this.displayName, this.phoneNumber, this.photoURL, this.direction, this.type, this.uid});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoURL'],
      direction: json['direction'],
      type: json['type'],
      uid: json['uid'],
    );
  }
}