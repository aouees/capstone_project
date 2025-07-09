class Country {
  final String name;

  Country({required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    final dynamic nameData = json['name'];
    if (nameData is Map<String, dynamic>) {
      final String? common = nameData['common'] as String?;
      if (common != null) {
        return Country(name: common);
      }
    }
    return Country(name: 'Unknown');
  }
}
