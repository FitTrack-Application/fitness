import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/statistic/models/weight_entry.dart';

class WeightGraph extends StatelessWidget {
  final List<WeightEntry> entries;
  final Color lineColor;
  final Color gradientColor;
  final String title;

  const WeightGraph({
    super.key,
    required this.entries,
    this.lineColor = Colors.blue,
    this.gradientColor = Colors.blue,
    this.title = 'Weight Tracking',
  });

  @override
  Widget build(BuildContext context) {
    // Sort entries by date to ensure proper display
    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find min and max values for better scaling
    final minWeight = sortedEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxWeight = sortedEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2;

    // Find min and max dates
    final minDate = sortedEntries.first.date;
    final maxDate = sortedEntries.last.date;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 2,
                          verticalInterval: 1,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitles: (value) {
                              // Convert the x-axis value to a date
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                minDate.millisecondsSinceEpoch +
                                    ((value / 10) * (maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch)).toInt(),
                              );

                              // Only show some dates to avoid overcrowding
                              if (value % 2 != 0) {
                                return '';
                              }

                              return DateFormat('MM/dd').format(date);
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitles: (value) {
                              return value.toStringAsFixed(0);
                            },
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black12),
                        ),
                        minX: 0,
                        maxX: 10,
                        minY: minWeight,
                        maxY: maxWeight,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _createSpots(sortedEntries, minDate, maxDate),
                            isCurved: true,
                            colors: [lineColor],
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [
                                gradientColor.withOpacity(0.3),
                                gradientColor.withOpacity(0.0),
                              ],
                              gradientFrom: const Offset(0, 0),
                              gradientTo: const Offset(0, 1),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey.shade800,
                            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final date = DateTime.fromMillisecondsSinceEpoch(
                                  minDate.millisecondsSinceEpoch +
                                      ((barSpot.x / 10) * (maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch)).toInt(),
                                );

                                return LineTooltipItem(
                                  '${DateFormat('MM/dd/yyyy').format(date)}\n',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${barSpot.y.toStringAsFixed(1)} kg',
                                      style: TextStyle(
                                        color: lineColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
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

  List<FlSpot> _createSpots(List<WeightEntry> entries, DateTime minDate, DateTime maxDate) {
    final totalDuration = maxDate.difference(minDate).inMilliseconds;

    return entries.map((entry) {
      // Convert date to a value between 0 and 10 for the x-axis
      final xValue = (entry.date.difference(minDate).inMilliseconds / totalDuration) * 10;
      return FlSpot(xValue, entry.weight);
    }).toList();
  }
}
