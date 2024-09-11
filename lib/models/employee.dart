class Employee {
  final String id;
  final String name;
  final String email;
  final String avatar;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['emailId'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }
}
