class Employee {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String? createdAt;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    this.createdAt,
  });

  // Factory constructor to create Employee object from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['emailId'] ?? '',
      avatar: json['avatar'] ?? '',
      mobile: json['mobile'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      createdAt: json['createdAt'] != null ? json['createdAt'] : null,
    );
  }

  // Method to convert Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
      'createdAt': createdAt,
    };
  }
}
