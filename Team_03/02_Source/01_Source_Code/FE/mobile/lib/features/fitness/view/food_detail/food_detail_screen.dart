import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/calorie_summary.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/custom_divider.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/food_info_section.dart';
import 'package:provider/provider.dart';

import '../../models/meal_log.dart';
import '../../services/repository/food_repository.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../../viewmodels/food_detail_viewmodel.dart';

class FoodDetailScreen extends StatelessWidget {
  final String foodId;
  final String mealLogId;
  final bool isEdit;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
    required this.mealLogId,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    print('mealId: $mealLogId');

    return ChangeNotifierProvider(
      create: (context) =>
      FoodDetailViewModel(FoodRepository())..loadFood(foodId),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              isEdit ? 'Edit Food' : 'Add Food',
              style: textTheme.titleMedium,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => GoRouter.of(context).pop(),
            ),
            actions: [
              Consumer2<FoodDetailViewModel, DiaryViewModel>(
                builder: (context, foodVM, diaryVM, child) {
                  final food = foodVM.food;

                  if (foodVM.loadState != LoadState.loaded || food == null) {
                    return const SizedBox.shrink();
                  }

                  final isAdding = diaryVM.isAddingFood(food.id);

                  return IconButton(
                    icon: isAdding
                        ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                        : Icon(Icons.check, color: colorScheme.primary),
                    onPressed: isAdding
                        ? null
                        : () async {
                      // await diaryVM.addFoodToDiary(
                      //   food,
                      //   foodVM.servings,
                      //   foodVM.selectedDate,
                      // );
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: Consumer<FoodDetailViewModel>(
            builder: (context, viewModel, child) {
              switch (viewModel.loadState) {
                case LoadState.loading:
                  return _buildLoadingState(context);
                case LoadState.error:
                  return _buildErrorState(context, viewModel);
                case LoadState.timeout:
                  return _buildTimeoutState(context, viewModel);
                case LoadState.loaded:
                  return _buildLoadedState(context, viewModel, textTheme);
                default:
                  return _buildLoadingState(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading food information...',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, FoodDetailViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load food information',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage ?? 'Unknown error occurred',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () => viewModel.loadFood(foodId),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutState(
      BuildContext context, FoodDetailViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_off,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Connection Timeout',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'The server is taking too long to respond.\nPlease check your internet connection.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () => viewModel.loadFood(foodId),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, FoodDetailViewModel viewModel,
      TextTheme textTheme) {
    final food = viewModel.food;
    final colorScheme = Theme.of(context).colorScheme;

    if (food == null) {
      return Center(
        child: Text(
          'No food information available',
          style: textTheme.bodyLarge,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            food.name,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Number of Servings',
            value: viewModel.servings.toString(),
            onTap: () => _editServings(context, viewModel),
          ),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Serving Size',
            value: "${food.servingSize} ${food.unit}",
            onTap: () {},
          ),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Meal Type',
            value: _getMealTypeDisplayName(viewModel.selectedMealType),
            onTap: () => _selectMealType(context, viewModel),
          ),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Date & Time',
            value:
            "${viewModel.selectedDate.day}/${viewModel.selectedDate.month}/${viewModel.selectedDate.year} - ${viewModel.selectedDate.hour}:${viewModel.selectedDate.minute.toString().padLeft(2, '0')}",
            onTap: () => _selectDateTime(context, viewModel),
          ),
          const CustomDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              CalorieSummary(
                calories: food.calories * viewModel.servings,
                carbs: food.carbs * viewModel.servings,
                fat: food.fat * viewModel.servings,
                protein: food.protein * viewModel.servings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMealTypeDisplayName(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'BREAKFAST';
      case MealType.lunch:
        return 'LUNCH';
      case MealType.dinner:
        return 'DINNER';
      default:
        return 'BREAKFAST';
    }
  }

  Future<void> _selectMealType(
      BuildContext context, FoodDetailViewModel viewModel) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Meal Type',
          style: textTheme.titleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMealTypeOption(
                context,
                MealType.breakfast,
                viewModel,
                Icons.wb_sunny_outlined,
              ),
              const SizedBox(height: 8),
              _buildMealTypeOption(
                context,
                MealType.lunch,
                viewModel,
                Icons.restaurant_outlined,
              ),
              const SizedBox(height: 8),
              _buildMealTypeOption(
                context,
                MealType.dinner,
                viewModel,
                Icons.nights_stay_outlined,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeOption(
      BuildContext context,
      MealType mealType,
      FoodDetailViewModel viewModel,
      IconData icon,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = viewModel.selectedMealType == mealType;

    return InkWell(
      onTap: () {
        viewModel.updateMealType(mealType);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          // Using a more subtle background color with lower opacity
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 16),
            Text(
              _getMealTypeDisplayName(mealType),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                // Making sure text color has good contrast with the background
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editServings(
      BuildContext context, FoodDetailViewModel viewModel) async {
    TextEditingController controller =
    TextEditingController(text: viewModel.servings.toString());
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Servings'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of servings',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              int? newServings = int.tryParse(controller.text);
              if (newServings != null && newServings >= 1) {
                viewModel.updateServings(newServings);
                Navigator.pop(context);
              }
            },
            child: Text(
              'OK',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(
      BuildContext context, FoodDetailViewModel viewModel) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (!context.mounted) {
        return;
      }

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(viewModel.selectedDate),
      );

      viewModel.updateSelectedDate(DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? viewModel.selectedDate.hour,
        pickedTime?.minute ?? viewModel.selectedDate.minute,
      ));
    }
  }
}