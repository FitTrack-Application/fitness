import 'package:intl/intl.dart';

class StepEntry {
  final DateTime date;
  final int steps;

  StepEntry({
    required this.date,
    required this.steps,
  });
  factory StepEntry.fromJson(Map<String, dynamic> json) {
    return StepEntry(
      steps: json['steps'], // Parse steps as an integer
      date: DateFormat('yyyy-MM-dd')
          .parse(json['date']), // Parse date using the provided format
    );
  }
}
