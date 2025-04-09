import 'package:intl/intl.dart';

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({required this.weight, required this.date});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: double.parse(json['weight']), // Parse weight as double
      date: DateFormat('dd/MM/yyyy').parse(json['date']), // Parse date using the provided format
    );
  }
}