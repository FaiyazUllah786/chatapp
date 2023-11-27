class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final DateTime lastSeen;
  final String phoneNumber;
  final List<dynamic> groupId;

  UserModel(
      {required this.name,
      required this.uid,
      required this.profilePic,
      required this.isOnline,
      required this.lastSeen,
      required this.phoneNumber,
      required this.groupId});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uid": uid,
      "profilePic": profilePic,
      "isOnline": isOnline,
      'lastSeen': lastSeen,
      "phoneNumber": phoneNumber,
      "groupId": groupId
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'],
        uid: map['uid'],
        profilePic: map['profilePic'],
        isOnline: map['isOnline'],
        lastSeen: map['lastSeen'].toDate(),
        phoneNumber: map['phoneNumber'],
        groupId: map['groupId']);
  }
}
