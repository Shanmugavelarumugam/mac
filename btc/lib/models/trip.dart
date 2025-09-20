class Trip {
  final int id;
  final String place;
  final String date;
  final List<String> members;
  final int userId; // <-- add this

  Trip({
    required this.id,
    required this.place,
    required this.date,
    required this.members,
    required this.userId, // <-- add this
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      place: json['place'],
      date: json['date'],
      members: List<String>.from(json['members'] ?? []),
      userId: json['userId'], // <-- add this
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place,
      'date': date,
      'members': members,
      'userId': userId, // <-- add this
    };
  }
}
