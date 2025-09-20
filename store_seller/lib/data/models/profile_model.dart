class SellerProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String businessType;
  final String? gstNumber;
  final String? panNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? bankAccountNumber;
  final String? bankName;
  final String? ifscCode;
  final String? upiId;
  final String paymentStatus;
  final String kycStatus;
  final bool isVerified;
  final List<dynamic> documents;
  final int rating;
  final int totalSales;
  final String status;
  final bool isBlocked;
  final String? blockReason;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  SellerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessType,
    this.gstNumber,
    this.panNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.bankAccountNumber,
    this.bankName,
    this.ifscCode,
    this.upiId,
    required this.paymentStatus,
    required this.kycStatus,
    required this.isVerified,
    required this.documents,
    required this.rating,
    required this.totalSales,
    required this.status,
    required this.isBlocked,
    this.blockReason,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      gstNumber: json['gstNumber'],
      panNumber: json['panNumber'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      bankAccountNumber: json['bankAccountNumber'],
      bankName: json['bankName'],
      ifscCode: json['ifscCode'],
      upiId: json['upiId'],
      paymentStatus: json['paymentStatus'],
      kycStatus: json['kycStatus'],
      isVerified: json['isVerified'],
      documents: json['documents'] ?? [],
      rating: json['rating'],
      totalSales: json['totalSales'],
      status: json['status'],
      isBlocked: json['isBlocked'],
      blockReason: json['blockReason'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {"name": name};
}
