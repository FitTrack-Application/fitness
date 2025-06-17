import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/calorie_summary.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/custom_divider.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/food_info_section.dart';
import 'package:provider/provider.dart';

import '../../models/meal_log.dart';
import '../../models/serving_unit.dart';
import '../../services/repository/food_repository.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../../viewmodels/food_detail_viewmodel.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;
  final String mealLogId;
  final bool isEdit;
  final double numberOfServings;
  final String mealEntryId;
  final MealType mealType;
  final String? servingUnitId;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
    this.mealLogId = '',
    this.mealEntryId = '',
    required this.isEdit,
    this.numberOfServings = 100,
    required this.mealType,
    this.servingUnitId,
  });

  @override
  State<StatefulWidget> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late final FoodDetailViewModel _foodVM;

  @override
  void initState() {
    super.initState();
    print('widget.servingUnitId: ${widget.servingUnitId}');
    _foodVM = FoodDetailViewModel(FoodRepository())
      ..loadFood(widget.foodId,
          servingUnitId:
          widget.servingUnitId ?? '',
          numberOfServings: widget.numberOfServings);
    _foodVM.updateServingSize(widget.numberOfServings);
    _foodVM.selectedMealType = widget.mealType;
    _foodVM.fetchAllServingUnits(widget.servingUnitId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<FoodDetailViewModel>.value(
      value: _foodVM,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isEdit ? 'Edit Food' : 'Add Food',
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

                  final isAdding = widget.isEdit 
                      ? diaryVM.isAddingFood(widget.mealEntryId)
                      : diaryVM.isAddingFood(food.id);

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
                        : Icon(Icons.add, color: colorScheme.primary),
                    onPressed: isAdding
                        ? null
                        : () async {
                            if (widget.isEdit) {
                              await diaryVM.editFoodInDiary(
                                  mealEntryId: widget.mealEntryId,
                                  foodId: food.id,
                                  servingUnitId: foodVM
                                          .selectedServingUnit?.id ??
                                      '9b0f9cf0-1c6e-4c1e-a3a1-8a9fddc20a0ba',
                                  numberOfServings: foodVM.servingSize);
                            } else {
                              await diaryVM.addFoodToDiary(
                                mealLogId: widget.mealLogId,
                                foodId: food.id,
                                servingUnitId: foodVM.selectedServingUnit?.id ??
                                    '',
                                numberOfServings: foodVM.servingSize,
                              );
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.isEdit 
                                      ? 'Food updated successfully' 
                                      : 'Food added successfully',
                                  ),
                                  backgroundColor: colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              context.pop();
                            }
                          },
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Consumer<FoodDetailViewModel>(
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
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox.shrink();
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
            onPressed: () => viewModel.loadFood(
              widget.foodId,
              servingUnitId: widget.servingUnitId ?? '',
              numberOfServings: widget.numberOfServings,
            ),
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
            onPressed: () => viewModel.loadFood(widget.foodId),
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
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (food.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
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
            value: viewModel.servingSize.toString(),
            onTap: () => _editServings(context, viewModel),
          ),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Serving Unit',
            value: viewModel.selectedServingUnit?.unitName ?? 'Grams',
            onTap: () => _selectServingUnit(context, viewModel),
          ),
          const CustomDivider(),
          FoodInfoSection(
            label: 'Meal Type',
            value: _getMealTypeDisplayName(viewModel.selectedMealType),
            // onTap: () => _selectMealType(context, viewModel),
            onTap: () {},
          ),
          const CustomDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              CalorieSummary(
                calories: food.calories,
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

  String _getMealTypeDisplayName(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'BREAKFAST';
      case MealType.lunch:
        return 'LUNCH';
      case MealType.dinner:
        return 'DINNER';
      case MealType.snack:
        return 'SNACK';
    }
  }

  Future<void> _selectServingUnit(
      BuildContext context, FoodDetailViewModel viewModel) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Serving Unit',
          style: textTheme.titleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var unit in viewModel.servingUnits) ...[
                _buildServingUnitOption(
                  context,
                  unit,
                  viewModel,
                ),
                const SizedBox(height: 8),
              ]
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

  Widget _buildServingUnitOption(
    BuildContext context,
    ServingUnit servingUnit,
    FoodDetailViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = viewModel.selectedServingUnit?.id == servingUnit.id;

    return InkWell(
      onTap: () {
        viewModel.updateServingUnit(servingUnit);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              '${servingUnit.unitName} (${servingUnit.unitSymbol})',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    final controller =
        TextEditingController(text: viewModel.servingSize.toString());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Servings'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of servings',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
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
              final newServings = double.tryParse(controller.text);
              if (newServings != null && newServings >= 1) {
                viewModel.updateServingSize(newServings);
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
}
