class Diamond {
  int id;
  double caratWeight;
  String clarity;
  String color;
  String currentHolder;
  String receivedFrom;
  DateTime receivedDate;
  String status;
  double price;
  String notes;
  String? firebaseKey; // Store Firebase key for updates

  Diamond(
      this.id,
      this.caratWeight,
      this.clarity,
      this.color,
      this.currentHolder,
      this.receivedFrom,
      this.receivedDate,
      this.status,
      this.price,
      this.notes,
      {this.firebaseKey}
      );

  // Convert Diamond object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caratWeight': caratWeight,
      'clarity': clarity,
      'color': color,
      'currentHolder': currentHolder,
      'receivedFrom': receivedFrom,
      'receivedDate': receivedDate.millisecondsSinceEpoch,
      'status': status,
      'price': price,
      'notes': notes,
    };
  }

  // Create Diamond object from Firebase data
  factory Diamond.fromMap(Map<dynamic, dynamic> map, String key) {
    return Diamond(
      map['id'],
      map['caratWeight'].toDouble(),
      map['clarity'],
      map['color'],
      map['currentHolder'],
      map['receivedFrom'],
      DateTime.fromMillisecondsSinceEpoch(map['receivedDate']),
      map['status'],
      map['price'].toDouble(),
      map['notes'] ?? '',
      firebaseKey: key,
    );
  }
}