import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/statistic/models/step_entry.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/features/statistic/view/dashboard/widget/step_graph_theme.dart';
import 'dart:math' as math;

class StepGraph extends StatelessWidget {
  final List<StepEntry> entries;
  final String title;
  final VoidCallback? onAddPressed;

  const StepGraph({
    super.key,
    required this.entries,
    this.title = 'Daily Steps',
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Handle empty entries by providing default data or showing a placeholder
    final hasData = entries.isNotEmpty;
    final sortedEntries = hasData
        ? (() {
            final sortedList = List<StepEntry>.from(entries);
            sortedList.sort((a, b) => a.date.compareTo(b.date));
            return sortedList;
          })()
        : [
            StepEntry(date: DateTime.now(), steps: 0),
            StepEntry(
                date: DateTime.now().subtract(const Duration(days: 1)),
                steps: 0),
          ];

    // Find max value for better scaling
    final maxSteps = hasData
        ? sortedEntries.map((e) => e.steps).reduce((a, b) => a > b ? a : b)
        : 5000;

    // Calculate appropriate y-axis max value (round up to nearest 5000)
    final yMax = ((maxSteps / 5000).ceil() * 5000).toDouble();

    // Find min and max dates
    final minDate = sortedEntries.first.date.subtract(const Duration(days: 3));
    final maxDate = sortedEntries.last.date.add(const Duration(days: 3));

    // Calculate date intervals for x-axis
    final totalDays = maxDate.difference(minDate).inDays;
    final daysInterval = _calculateOptimalDaysInterval(totalDays);

    // Calculate bar width based on number of entries
    final barWidth = math.min(3.0, 8.0 / sortedEntries.length);

    return Container(
      decoration: StepGraphTheme.containerDecoration(context),
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
                        onPressed: () {
                          GoRouter.of(context).push('/steps/add');
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                        color: AccentColors.red300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (hasData)
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18, left: 0, top: 24, bottom: 12),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: yMax,
                            minY: 0,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipRoundedRadius: 8,
                                tooltipPadding: const EdgeInsets.all(8),
                                tooltipMargin: 8,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final entry = sortedEntries[groupIndex];
                                  final date = DateFormat('MMM d, yyyy')
                                      .format(entry.date);
                                  return BarTooltipItem(
                                    '$date\n',
                                    TextStyle(
                                      color: StepGraphTheme.tooltipTextColor(
                                          context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${NumberFormat('#,###').format(entry.steps)} steps',
                                        style: TextStyle(
                                          color:
                                              StepGraphTheme.tooltipTextColor(
                                                  context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < sortedEntries.length) {
                                      final entry =
                                          sortedEntries[value.toInt()];
                                      final date = entry.date;

                                      // Only show some dates to avoid overcrowding
                                      final daysSinceStart =
                                          date.difference(minDate).inDays;
                                      if (daysSinceStart % daysInterval == 0) {
                                        return Transform.rotate(
                                          angle: -0.5,
                                          child: Text(
                                            DateFormat('MM/dd').format(date),
                                            style:
                                                StepGraphTheme.titleDataStyle(
                                                    context),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    // Show intervals of 5000 steps
                                    if (value % 5000 == 0) {
                                      // Format with commas for thousands
                                      final formattedValue =
                                          NumberFormat('#,###').format(value);
                                      return Text(
                                        formattedValue,
                                        style: StepGraphTheme.titleDataStyle(
                                            context),
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
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 5000, // 5000 steps interval
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: StepGraphTheme.gridLineColor(context),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border:
                                  Border.all(color: Colors.black26, width: 1),
                            ),
                            barGroups: _createBarGroups(
                                context, sortedEntries, barWidth),
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No data available. Add your step logs to see the graph.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
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

  // Create bar groups for the chart
  List<BarChartGroupData> _createBarGroups(
    BuildContext context,
    List<StepEntry> entries,
    double width,
  ) {
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.steps.toDouble(),
            gradient: const LinearGradient(
              colors: [
                AccentColors.red300,
                AccentColors.red200,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            width: width * 14, // Adjust width based on number of bars
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  // Calculate optimal interval for date labels based on total days
  int _calculateOptimalDaysInterval(int totalDays) {
    if (totalDays <= 7) {
      return 1; // Show every day for a week or less
    } else if (totalDays <= 14) {
      return 2; // Show every other day for two weeks
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
