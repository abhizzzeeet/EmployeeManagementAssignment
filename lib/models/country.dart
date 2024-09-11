class Country {
  final String id;
  final String name;
  final String flag;

  Country({required this.id, required this.name, required this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? '',
      name: json['country'] ?? '',
      flag: json['flag'] ?? '',
    );
  }
}