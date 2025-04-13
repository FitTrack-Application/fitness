import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/fitness/models/exercise.dart';
import 'package:mobile/features/fitness/models/food.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/diary_viewmodel.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DiaryViewModel>(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          return _buildDiaryContent(viewModel, context);
        },
      ),
    );
  }

  Widget _buildDiaryContent(DiaryViewModel viewModel, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.fetchDiaryForSelectedDate();
      },
      child: Column(
        children: [
          _buildDateSelector(viewModel, context),
          _buildCaloriesCard(viewModel, context),
          // Tab chính: Food và Exercise
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'FOOD'),
              Tab(text: 'EXERCISE'),
            ],
          ),
          // TabBarView chính
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Food với 3 danh sách
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Breakfast
                      _buildMealList(
                        viewModel,
                        context,
                        'Breakfast',
                        viewModel.breakfastItems,
                        viewModel.breakfastCalories,
                        MealType.breakfast,
                      ),
                      // Lunch
                      _buildMealList(
                        viewModel,
                        context,
                        'Lunch',
                        viewModel.lunchItems,
                        viewModel.lunchCalories,
                        MealType.lunch,
                      ),
                      // Dinner
                      _buildMealList(
                        viewModel,
                        context,
                        'Dinner',
                        viewModel.dinnerItems,
                        viewModel.dinnerCalories,
                        MealType.dinner,
                      ),
                    ],
                  ),
                ),
                // Tab Exercise
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildExerciseList(viewModel, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(DiaryViewModel viewModel, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: viewModel.goToPreviousDay,
          ),
          Text(
            viewModel.isSelectedDateToday
                ? 'Today'
                : DateFormat('MM/dd/yyyy').format(viewModel.selectedDate),
            style: textTheme.titleSmall,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: viewModel.goToNextDay,
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(DiaryViewModel viewModel, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calories Remaining', style: textTheme.titleSmall),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCalorieColumn(
                      viewModel.calorieGoal.toInt(), 'Goal', context),
                  const SizedBox(width: 12),
                  Text('-', style: textTheme.bodySmall),
                  const SizedBox(width: 12),
                  _buildCalorieColumn(
                      viewModel.caloriesConsumed.toInt(), 'Food', context),
                  const SizedBox(width: 12),
                  Text('+', style: textTheme.bodySmall),
                  const SizedBox(width: 12),
                  _buildCalorieColumn(
                      viewModel.caloriesBurned.toInt(), 'Exercise', context),
                  const SizedBox(width: 12),
                  Text('=', style: textTheme.bodySmall),
                  const SizedBox(width: 12),
                  _buildCalorieColumn(
                      viewModel.caloriesRemaining.toInt(),
                      'Remaining',
                      context,
                      bold: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieColumn(int value, String label, BuildContext context,
      {bool bold = false}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value.toString(),
          style: bold
              ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
              : textTheme.bodyMedium,
        ),
        Text(label,
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildMealList(
      DiaryViewModel viewModel,
      BuildContext context,
      String mealTitle,
      List<Food> foodItems,
      int calories,
      MealType mealType,
      ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(mealTitle, style: textTheme.titleSmall),
                Text('$calories', style: textTheme.titleSmall),
              ],
            ),
          ),
          ...foodItems.map((item) => _buildFoodItem(item, context, () {
            context.push('/food/${viewModel.diaryId}/${item.id}/edit');
          })),
          TextButton(
            onPressed: () {
              // Truyền mealType vào màn hình tìm kiếm
              context.push('/search/${viewModel.diaryId}?mealType=${mealType.toString().split('.').last}');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'ADD FOOD',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(DiaryViewModel viewModel, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercise', style: textTheme.titleSmall),
                Text('${viewModel.caloriesBurned.toInt()}',
                    style: textTheme.titleSmall),
              ],
            ),
          ),
          ...viewModel.exerciseItems
              .map((item) => _buildExerciseItem(item, context)),
          TextButton(
            onPressed: () {
              // Thêm navigation đến màn add exercise
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'ADD EXERCISE',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Food item, BuildContext context, VoidCallback onTap) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            title: Text(
              item.name,
              style: textTheme.bodyMedium,
            ),
            subtitle: Text(
                "${item.calories} cal, Carbs: ${item.carbs}g, Fat: ${item.fat}g, Protein: ${item.protein}g",
                style: textTheme.bodySmall),
            trailing: Text('${item.calories}'),
          ),
          const Divider(
            height: 0.1,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Exercise item, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListTile(
          title: Text(item.exerciseName),
          subtitle: Text("${item.duration} phút - ${item.description}"),
          trailing: Text('${item.calories}', style: textTheme.titleSmall),
        ),
        const Divider(
          height: 0.1,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}