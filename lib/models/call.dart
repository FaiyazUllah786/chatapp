class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String recieverId;
  final String recieverName;
  final String recieverPic;
  final String callId;
  final bool hasDialed;
  final DateTime timeCall;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.recieverId,
    required this.recieverName,
    required this.recieverPic,
    required this.callId,
    required this.hasDialed,
    required this.timeCall,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'recieverId': recieverId,
      'recieverName': recieverName,
      'recieverPic': recieverPic,
      'callId': callId,
      'hasDialed': hasDialed,
      'timeCall': timeCall
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
        callerId: map['callerId'],
        callerName: map['callerName'],
        callerPic: map['callerPic'],
        recieverId: map['recieverId'],
        recieverName: map['recieverName'],
        recieverPic: map['recieverPic'],
        callId: map['callId'],
        hasDialed: map['hasDialed'],
        timeCall: map['timeCall'].toDate());
  }
}
