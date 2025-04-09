import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/calorie_summary.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/custom_divider.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/food_info_section.dart';
import 'package:provider/provider.dart';

import '../../services/repository/food_repository.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../../viewmodels/food_detail_viewmodel.dart';

class FoodDetailScreen extends StatelessWidget {
  final String foodId;
  final int diaryId;
  final bool isEdit;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
    required this.diaryId,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
                            await diaryVM.addFoodToDiary(
                              food,
                              foodVM.servings,
                              foodVM.selectedDate,
                            );
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
          const SizedBox(height: 8),
          if (food.description.isNotEmpty)
            Text(
              food.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
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
                carbs: food.carbs,
                fat: food.fat,
                protein: food.protein,
              ),
            ],
          ),
        ],
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
