import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';
import 'package:mobile/features/statistic/models/weight_entry.dart';
import 'package:mobile/features/statistic/view/dashboard/weight_graph.dart';

class DashboardScreen extends StatelessWidget {
    final List<WeightEntry> weightEntries = [
    WeightEntry(date: DateTime(2023, 1, 1), weight: 80.5),
    WeightEntry(date: DateTime(2023, 1, 8), weight: 79.8),
    WeightEntry(date: DateTime(2023, 1, 15), weight: 79.2),
    WeightEntry(date: DateTime(2023, 1, 22), weight: 78.5),
    WeightEntry(date: DateTime(2023, 1, 29), weight: 77.9),
    WeightEntry(date: DateTime(2023, 2, 5), weight: 78.2),
    WeightEntry(date: DateTime(2023, 2, 12), weight: 77.5),
    WeightEntry(date: DateTime(2023, 2, 19), weight: 76.8),
    WeightEntry(date: DateTime(2023, 2, 26), weight: 76.2),
    WeightEntry(date: DateTime(2023, 3, 5), weight: 75.5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Dashboard Click Me",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  GoRouter.of(context).push('/welcome');
                },
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
              children: [
                WeightGraph(
                entries: weightEntries,
                lineColor: Colors.blue,
                title: 'Weight History',
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/weight/add');
                  },
                  child: Icon(Icons.add),
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
