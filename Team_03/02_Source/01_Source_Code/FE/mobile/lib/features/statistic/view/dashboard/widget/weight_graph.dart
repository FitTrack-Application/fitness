import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/statistic/models/weight_entry.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/features/statistic/view/dashboard/widget/weight_graph_theme.dart';

class WeightGraph extends StatelessWidget {
  final List<WeightEntry> entries;
  final Color lineColor;
  final Color gradientColor;
  final String title;
  final VoidCallback? onAddPressed;
  final double weightGoal;

  const WeightGraph({
    super.key,
    required this.entries,
    this.lineColor = HighlightColors.highlight500,
    this.gradientColor = HighlightColors.highlight500,
    this.weightGoal = 68.0,
    this.title = 'Weight Tracking',
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Sort entries by date to ensure proper display
    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find min and max values for better scaling
    double minWeight =
        sortedEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 4;
    double maxWeight =
        sortedEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 4;

    // Round min and max to align with 4 kg intervals
    minWeight = (minWeight / 4).floor() * 4.0;
    maxWeight = (maxWeight / 4).ceil() * 4.0;

    // Find min and max dates and add padding of 3 days
    final minDate = sortedEntries.first.date.subtract(const Duration(days: 3));
    final maxDate = sortedEntries.last.date.add(const Duration(days: 3));

    // Calculate date intervals for x-axis
    final totalDays = maxDate.difference(minDate).inDays;
    final daysInterval = _calculateOptimalDaysInterval(totalDays);

    return Container(
      decoration: WeightGraphTheme.containerDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: onAddPressed,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                        color: HighlightColors.highlight500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18, left: 0, top: 24, bottom: 12),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 4,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: WeightGraphTheme.gridLineColor(context),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: daysInterval.toDouble(),
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  final date = minDate
                                      .add(Duration(days: value.toInt()));
                                  return Text(
                                    DateFormat('MM/dd').format(date),
                                    style: WeightGraphTheme.titleDataStyle(
                                        context),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 4,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: WeightGraphTheme.titleDataStyle(
                                        context),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black26, width: 1),
                          ),
                          minX: 0,
                          maxX: totalDays.toDouble(),
                          minY: minWeight,
                          maxY: maxWeight,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _createSpots(
                                  sortedEntries, minDate, maxDate, totalDays),
                              isCurved: true,
                              color: lineColor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: weightGoal,
                                color: HighlightColors.highlight200,
                                strokeWidth: 2,
                                dashArray: [5, 5],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createSpots(List<WeightEntry> entries, DateTime minDate,
      DateTime maxDate, int totalDays) {
    final totalDuration = maxDate.difference(minDate).inMilliseconds;

    return entries.map((entry) {
      final xValue = entry.date.difference(minDate).inMilliseconds /
          totalDuration *
          totalDays;
      return FlSpot(xValue, entry.weight);
    }).toList();
  }

  int _calculateOptimalDaysInterval(int totalDays) {
    if (totalDays <= 7) {
      return 1;
    } else if (totalDays <= 30) {
      return 3;
    } else if (totalDays <= 90) {
      return 7;
    } else if (totalDays <= 365) {
      return 30;
    } else {
      return 90;
    }
  }
}
