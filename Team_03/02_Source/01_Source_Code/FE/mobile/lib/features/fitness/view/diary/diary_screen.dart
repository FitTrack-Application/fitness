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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchDiaryForSelectedDate(),
          ),
        ],
      ),
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
            _buildDateSelector(viewModel),
            _buildCaloriesCard(viewModel),
            _buildFoodList(viewModel, context),
            _buildExerciseList(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(DiaryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: viewModel.goToNextDay,
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(DiaryViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Calories Remaining', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCalorieColumn(viewModel.calorieGoal.toInt(), 'Goal'),
                  const SizedBox(width: 8),
                  const Text('-', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  _buildCalorieColumn(viewModel.caloriesConsumed.toInt(), 'Food'),
                  const SizedBox(width: 8),
                  const Text('+', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  _buildCalorieColumn(viewModel.caloriesBurned.toInt(), 'Exercise'),
                  const SizedBox(width: 8),
                  const Text('=', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  _buildCalorieColumn(viewModel.caloriesRemaining.toInt(), 'Remaining', bold: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieColumn(int value, String label, {bool bold = false}) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 15, fontWeight: bold ? FontWeight.bold : null),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFoodList(DiaryViewModel viewModel, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Breakfast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${viewModel.caloriesConsumed.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...viewModel.foodItems.map((item) => _buildFoodItem(item, () {
            context.push('/food/${viewModel.diaryId}/${item.id}/edit');
          })),
          TextButton(
            onPressed: () {
              context.push('/search/${viewModel.diaryId}');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ADD FOOD', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(DiaryViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${viewModel.caloriesBurned.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...viewModel.exerciseItems.map((item) => _buildExerciseItem(item)),
          TextButton(
            onPressed: () {
              // Thêm navigation đến màn add exercise
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('ADD EXERCISE', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Food item, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            title: Text(item.name),
            subtitle: Text(
                "${item.calories} cal, Carbs: ${item.carbs}g, Fat: ${item.fat}g, Protein: ${item.protein}g"),
            trailing: Text('${item.calories}', style: const TextStyle(fontSize: 16)),
          ),
          const Divider(height: 1, indent: 16),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Exercise item) {
    return Column(
      children: [
        ListTile(
          title: Text(item.exerciseName),
          subtitle: Text("${item.duration} phút - ${item.description}"),
          trailing: Text('${item.calories}', style: const TextStyle(fontSize: 16)),
        ),
        const Divider(height: 1, indent: 16),
      ],
    );
  }
}