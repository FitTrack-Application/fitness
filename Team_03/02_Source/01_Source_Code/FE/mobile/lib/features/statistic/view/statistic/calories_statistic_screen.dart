// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:mobile/common/widgets/status_dialog/status_dialog.dart';
// import 'package:mobile/cores/constants/colors.dart';
// import 'package:mobile/cores/constants/enums/status_enum.dart';
// import 'package:mobile/features/statistic/models/response/recent_calories_response.dart';
// import 'package:mobile/features/statistic/services/calories_statistic_service.dart';
//
// class CaloriesStatisticScreen extends StatefulWidget {
//   final String userId;
//
//   const CaloriesStatisticScreen({super.key, required this.userId});
//
//   @override
//   State<CaloriesStatisticScreen> createState() => _CaloriesStatisticScreenState();
// }
//
// class _CaloriesStatisticScreenState extends State<CaloriesStatisticScreen> {
//   final CaloriesApiService _apiService = CaloriesApiService();
//   RecentCaloriesData? _caloriesData;
//   bool _isLoading = false;
//   DateTime _selectedEndDate = DateTime.now();
//   String _selectedTab = 'Net'; // Tab "Total" hoặc "Net"
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       _caloriesData = await _apiService.getRecentCalories(userId: widget.userId);
//     } catch (e) {
//       showStatusDialog(
//         context,
//         status: StatusType.error,
//         title: 'Error',
//         message: 'Failed to load calories data: $e',
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _previousWeek() {
//     setState(() {
//       _selectedEndDate = _selectedEndDate.subtract(const Duration(days: 7));
//       _fetchData();
//     });
//   }
//
//   void _nextWeek() {
//     setState(() {
//       _selectedEndDate = _selectedEndDate.add(const Duration(days: 7));
//       _fetchData();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final startDate = _selectedEndDate.subtract(const Duration(days: 6));
//     final dateFormat = DateFormat('d MMMM');
//     final weekRange = '${dateFormat.format(startDate)} - ${dateFormat.format(_selectedEndDate)}';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nutrition'),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text('Export', style: TextStyle(color: Colors.blue)),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _caloriesData == null
//           ? const Center(child: Text('No data available'))
//           : SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTabs(),
//             _buildWeekSelector(weekRange),
//             _buildTotalNetTabs(),
//             _buildBarChart(),
//             _buildStatistics(),
//             _buildPremiumFeature(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabs() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildTab('Calories', isSelected: true),
//           const SizedBox(width: 16),
//           _buildTab('Nutrients', isSelected: false),
//           const SizedBox(width: 16),
//           _buildTab('Macros', isSelected: false),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTab(String title, {required bool isSelected}) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.blue : Colors.grey,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         if (isSelected)
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             height: 2,
//             width: 20,
//             color: Colors.blue,
//           ),
//       ],
//     );
//   }
//
//   Widget _buildWeekSelector(String weekRange) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_left),
//             onPressed: _previousWeek,
//           ),
//           Row(
//             children: [
//               const Text('Week View', style: TextStyle(color: Colors.grey)),
//               const SizedBox(width: 8),
//               Text(weekRange, style: const TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.arrow_right),
//             onPressed: _nextWeek,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTotalNetTabs() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildTotalNetTab('Total', isSelected: _selectedTab == 'Total'),
//           const SizedBox(width: 16),
//           _buildTotalNetTab('Net', isSelected: _selectedTab == 'Net'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTotalNetTab(String title, {required bool isSelected}) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedTab = title;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.grey[200] : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.black : Colors.grey,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBarChart() {
//     final List<double> netCalories = _caloriesData!.days.map((day) => day.netCalories).toList();
//     final double average = netCalories.isNotEmpty
//         ? netCalories.reduce((a, b) => a + b) / netCalories.length
//         : 0;
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SizedBox(
//         height: 200,
//         child: BarChart(
//           BarChartData(
//             alignment: BarChartAlignment.spaceAround,
//             maxY: 1600,
//             minY: 0,
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   reservedSize: 40,
//                   getTitlesWidget: (value, meta) {
//                     return Text(
//                       value.toInt().toString(),
//                       style: const TextStyle(fontSize: 12),
//                     );
//                   },
//                 ),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     if (value.toInt() == 7) return const Text('Avg');
//                     final dayIndex = value.toInt();
//                     final date = _caloriesData!.days[dayIndex].date;
//                     final dayOfWeek = DateFormat('E').format(DateTime.parse(date)).substring(0, 1);
//                     return Text('$dayOfWeek\n${DateTime.parse(date).day}');
//                   },
//                 ),
//               ),
//               topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             ),
//             borderData: FlBorderData(show: false),
//             gridData: const FlGridData(show: true),
//             barGroups: [
//               ...List.generate(7, (index) {
//                 return BarChartGroupData(
//                   x: index,
//                   barRods: [
//                     BarChartRodData(
//                       toY: netCalories[index],
//                       color: SupportColors.success300,
//                       width: 20,
//                     ),
//                   ],
//                 );
//               }),
//               BarChartGroupData(
//                 x: 7,
//                 barRods: [
//                   BarChartRodData(
//                     toY: average,
//                     color: Colors.grey,
//                     width: 20,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatistics() {
//     final netCalories = _caloriesData!.days.map((day) => day.netCalories).toList();
//     final totalNetCalories = netCalories.reduce((a, b) => a + b);
//     final netAverage = netCalories.isNotEmpty ? totalNetCalories / netCalories.length : 0;
//     final goal = _caloriesData!.goal;
//     final netUnderGoal = goal * 7 - totalNetCalories; // Giả định mục tiêu là hàng ngày
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Net Calories Under Weekly Goal',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           Text(
//             netUnderGoal.toStringAsFixed(0),
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Net Average',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           Text(
//             netAverage.toStringAsFixed(0),
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Goal',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           Text(
//             goal.toStringAsFixed(0),
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPremiumFeature() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.lock, color: Colors.orange),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Premium Feature',
//                     style: TextStyle(color: Colors.orange),
//                   ),
//                   const Text(
//                     'Foods Highest In Calories',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     'Unlock Premium to learn which of your logged foods are highest in calories.',
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('Go Premium'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }