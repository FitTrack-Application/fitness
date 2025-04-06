import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  // Mock data that can be replaced with API data later
  final double calorieGoal = 2390;
  final double caloriesConsumed = 417;
  final double caloriesBurned = 0;

  // Mock food data
  final List<FoodItem> foodItems = [
    FoodItem(
        name: "Fried Chicken",
        description: "Stouffers fried chicken, 1,0 package",
        calories: 340
    ),
    FoodItem(
        name: "trứng gà luộc",
        description: "1,0 (trứng)",
        calories: 77
    ),
  ];

  // Mock exercise data
  final List<ExerciseItem> exerciseItems = [];

  // Selected date - default to today
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Diary'),
        // Removed action icons as requested
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.subtract(const Duration(days: 1));
                      });
                    },
                  ),
                  Text(
                    _isToday(selectedDate) ? 'Today' : DateFormat('MM/dd/yyyy').format(selectedDate),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.add(const Duration(days: 1));
                      });
                    },
                  ),
                ],
              ),
            ),

            // Calories remaining card - Fixed overflow and removed "..." button
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Calories Remaining',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                calorieGoal.toInt().toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Text('Goal', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Text('-', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(
                                caloriesConsumed.toInt().toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Text('Food', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Text('+', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(
                                caloriesBurned.toInt().toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Text('Exercise', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Text('=', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(
                                (calorieGoal - caloriesConsumed + caloriesBurned).toInt().toString(),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const Text('Remaining', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Food list
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Breakfast',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_getTotalCalories(foodItems)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ...foodItems.map((item) => _buildFoodItem(item)),
                  TextButton(
                    onPressed: () {
                      context.push('/search');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'ADD FOOD',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Exercise list - Kept this section as requested (removed Lunch)
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Exercise',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_getTotalExerciseCalories(exerciseItems)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ...exerciseItems.map((item) => _buildExerciseItem(item)),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'ADD EXERCISE',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(FoodItem item) {
    return Column(
      children: [
        ListTile(
          title: Text(item.name),
          subtitle: Text(item.description),
          trailing: Text(
            '${item.calories}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Divider(height: 1, indent: 16),
      ],
    );
  }

  Widget _buildExerciseItem(ExerciseItem item) {
    return Column(
      children: [
        ListTile(
          title: Text(item.name),
          subtitle: Text(item.description),
          trailing: Text(
            '${item.calories}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Divider(height: 1, indent: 16),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  int _getTotalCalories(List<FoodItem> items) {
    return items.fold(0, (sum, item) => sum + item.calories);
  }

  int _getTotalExerciseCalories(List<ExerciseItem> items) {
    return items.fold(0, (sum, item) => sum + item.calories);
  }
}

class FoodItem {
  final String name;
  final String description;
  final int calories;

  FoodItem({required this.name, required this.description, required this.calories});
}

class ExerciseItem {
  final String name;
  final String description;
  final int calories;

  ExerciseItem({required this.name, required this.description, required this.calories});
}