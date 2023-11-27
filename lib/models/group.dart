class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final DateTime timeSent;
  final String groupPic;
  final List<String> membersUid;

  Group(
      {required this.senderId,
      required this.name,
      required this.groupId,
      required this.lastMessage,
      required this.timeSent,
      required this.groupPic,
      required this.membersUid});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'timeSent': timeSent,
      'groupPic': groupPic,
      'membersUid': membersUid
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
        senderId: map['senderId'],
        name: map['name'],
        groupId: map['groupId'],
        lastMessage: map['lastMessage'],
        timeSent: map['timeSent'].toDate(),
        groupPic: map['groupPic'],
        membersUid: List<String>.from(map['membersUid']));
  }
}
