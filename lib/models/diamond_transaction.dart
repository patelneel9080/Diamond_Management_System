class DiamondTransaction {
  int diamondId;
  DateTime date;
  String fromPerson;
  String toPerson;
  String action;
  String notes;

  DiamondTransaction(
      this.diamondId,
      this.date,
      this.fromPerson,
      this.toPerson,
      this.action,
      this.notes,
      );

  // Convert DiamondTransaction object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'diamondId': diamondId,
      'date': date.millisecondsSinceEpoch,
      'fromPerson': fromPerson,
      'toPerson': toPerson,
      'action': action,
      'notes': notes,
    };
  }

  // Create DiamondTransaction object from Firebase data
  factory DiamondTransaction.fromMap(Map<dynamic, dynamic> map) {
    return DiamondTransaction(
      map['diamondId'],
      DateTime.fromMillisecondsSinceEpoch(map['date']),
      map['fromPerson'],
      map['toPerson'],
      map['action'],
      map['notes'] ?? '',
    );
  }
}