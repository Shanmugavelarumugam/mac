class TripTransaction {
  final int id;
  final int tripId;
  final String name;
  final double amount;
  final String purpose;
  final String date;

  final String createdAt;
  final String updatedAt;

  TripTransaction({
    required this.id,
    required this.tripId,
    required this.name,
    required this.amount,
    required this.purpose,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripTransaction.fromJson(Map<String, dynamic> json) {
    return TripTransaction(
      id: json['id'],
      tripId: json['tripId'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      purpose: json['purpose'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
