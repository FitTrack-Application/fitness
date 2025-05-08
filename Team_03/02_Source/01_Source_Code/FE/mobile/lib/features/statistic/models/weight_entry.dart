import 'package:intl/intl.dart';

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({required this.weight, required this.date});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: json['weight'] is double
          ? json['weight']
          : double.parse(
              json['weight'].toString()), // Handle both double and String
      date: DateFormat('yyyy-MM-dd')
          .parse(json['date']), // Parse date using the provided format
    );
  }
}
