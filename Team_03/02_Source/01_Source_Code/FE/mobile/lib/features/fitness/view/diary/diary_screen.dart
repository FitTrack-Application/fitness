import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/fitness/models/exercise.dart';
import 'package:mobile/features/fitness/models/food.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/diary_viewmodel.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildDateSelector(viewModel, context),
            _buildCaloriesCard(viewModel, context),
            _buildFoodList(viewModel, context),
            _buildExerciseList(viewModel, context),
          ],
        ),
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

    return Card(
      child: Column(
        children: [
          Text('Calories Remaining', style: textTheme.titleMedium),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    viewModel.caloriesRemaining.toInt(), 'Remaining', context,
                    bold: true),
              ],
            ),
          ),
        ],
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

  Widget _buildFoodList(DiaryViewModel viewModel, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Food', style: textTheme.titleSmall),
                Text('${viewModel.caloriesConsumed.toInt()}',
                    style: textTheme.titleSmall),
              ],
            ),
          ),
          const Divider(height: 1),
          ...viewModel.foodItems
              .map((item) => _buildFoodItem(item, context, () {
                    context.push('/food/${viewModel.diaryId}/${item.id}/edit');
                  })),
          TextButton(
            onPressed: () {
              context.push('/search/${viewModel.diaryId}');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
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
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercise', style: textTheme.titleSmall),
                Text('${viewModel.caloriesBurned.toInt()}',
                    style: textTheme.titleSmall),
              ],
            ),
          ),
          const Divider(height: 1),
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
                  padding: const EdgeInsets.only(left: 16.0),
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
          const Divider(height: 1, indent: 16),
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
        const Divider(height: 1, indent: 16),
      ],
    );
  }
}
