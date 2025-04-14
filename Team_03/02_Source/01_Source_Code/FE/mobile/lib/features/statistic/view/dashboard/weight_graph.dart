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
  
  const WeightGraph({
    super.key,
    required this.entries,
    this.lineColor = HighlightColors.highlight500,
    this.gradientColor = HighlightColors.highlight500,
    this.title = 'Weight Tracking',
    this.onAddPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    // Sort entries by date to ensure proper display
    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    // Find min and max values for better scaling
    double minWeight = sortedEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 4;
    double maxWeight = sortedEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 4;
    
    // Round min and max to align with 4 kg intervals
    minWeight = (minWeight / 4).floor() * 4.0;
    maxWeight = (maxWeight / 4).ceil() * 4.0;
    
    // Find min and max dates
    final minDate = sortedEntries.first.date;
    final maxDate = sortedEntries.last.date;
    
    // Calculate date intervals for x-axis
    final totalDays = maxDate.difference(minDate).inDays;
    final daysInterval = _calculateOptimalDaysInterval(totalDays);
    
    return Container(
      decoration: WeightGraphTheme.containerDecoration(context), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
        children: [
          Card(
            elevation: 4,
            margin: EdgeInsets.zero, // Remove card margin
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
                children: [
                  // Title row with add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: WeightGraphTheme.cardTitleStyle(context),
                      ),
                      // Add button
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          GoRouter.of(context).push('/weight/add');
                        },
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
                      // Adjust padding to align with title
                      padding: const EdgeInsets.only(right: 18, left: 0, top: 24, bottom: 12),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 4, // 4 kg intervals
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: WeightGraphTheme.gridLineColor(context),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
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
                                interval: 2, // Adjust interval to avoid duplicates
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  // Convert the x-axis value to a date
                                  final date = DateTime.fromMillisecondsSinceEpoch(
                                    minDate.millisecondsSinceEpoch +
                                        ((value / 10) * (maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch)).toInt(),
                                  );
                                  
                                  // Only show labels at specific intervals to avoid overcrowding
                                  final daysSinceStart = date.difference(minDate).inDays;
                                  
                                  if (daysSinceStart % daysInterval == 0) {
                                    return Transform.rotate(
                                      angle: -0.5, // Slight rotation for better readability
                                      child: Text(
                                        DateFormat('MM/dd').format(date),
                                        style: WeightGraphTheme.titleDataStyle(context),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 4, // Keep the interval for weight labels
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value % 4 == 0) {
                                    return Text(
                                      '${value.toInt()} ',
                                      style: WeightGraphTheme.titleDataStyle(context),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black26, width: 1),
                          ),
                          minX: 0,
                          maxX: 10,
                          minY: minWeight,
                          maxY: maxWeight,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _createSpots(sortedEntries, minDate, maxDate),
                              isCurved: true,
                              color: lineColor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(
                                show: true,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    gradientColor.withOpacity(0.3),
                                    gradientColor.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              // Fix: Add tooltipBgColor for fl_chart 0.70.2
                              
                              tooltipRoundedRadius: 8,
                              tooltipPadding: const EdgeInsets.all(8),
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  final date = DateTime.fromMillisecondsSinceEpoch(
                                    minDate.millisecondsSinceEpoch +
                                        ((barSpot.x / 10) * (maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch)).toInt(),
                                  );
                                  
                                  return LineTooltipItem(
                                    '${DateFormat('MMM d, yyyy').format(date)}\n',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${barSpot.y.toStringAsFixed(1)} kg',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                            touchSpotThreshold: 20,
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
  
  // Calculate optimal interval for date labels based on total days
  int _calculateOptimalDaysInterval(int totalDays) {
    if (totalDays <= 7) {
      return 1; // Show every day for a week or less
    } else if (totalDays <= 30) {
      return 3; // Show every 3 days for a month
    } else if (totalDays <= 90) {
      return 7; // Show weekly for 3 months
    } else if (totalDays <= 365) {
      return 30; // Show monthly for a year
    } else {
      return 90; // Show quarterly for more than a year
    }
  }
}
