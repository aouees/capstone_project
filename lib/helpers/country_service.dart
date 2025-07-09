import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountryService {
  static Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://restcountries.com/v3.1/all?fields=name');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      final countries =
          jsonList.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
