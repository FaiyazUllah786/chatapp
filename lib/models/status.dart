class Status {
  final String uid;
  final String userName;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;
  Status({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.profilePic,
    required this.photoUrl,
    required this.createdAt,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'statusId': statusId,
      'whoCanSee': whoCanSee
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
        uid: map['uid'],
        userName: map['userName'],
        phoneNumber: map['phoneNumber'],
        profilePic: map['profilePic'],
        photoUrl: List<String>.from(map['photoUrl']),
        createdAt: map['createdAt'].toDate(),
        statusId: map['statusId'],
        whoCanSee: List<String>.from(map['whoCanSee']));
  }
}
