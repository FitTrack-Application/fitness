import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/services/repository/exercise_repository.dart';
import 'package:mobile/features/fitness/view/exercises/widget/exercise_info_section.dart';
import 'package:mobile/features/fitness/viewmodels/exercise_detail_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../models/serving_unit.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../food_detail/widget/custom_divider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final String workoutLogId;
  final double duration;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.workoutLogId,
    this.duration = 0,
  });

  @override
  State<StatefulWidget> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late final ExerciseDetailViewModel _exerciseVM;

  @override
  void initState() {
    super.initState();
    _exerciseVM = ExerciseDetailViewModel(ExerciseRepository())
      ..loadExercise(widget.exerciseId, duration: widget.duration);
    _exerciseVM.updateDuration(widget.duration);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<ExerciseDetailViewModel>.value(
      value: _exerciseVM,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Add Exercise',
              style: textTheme.titleMedium,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => GoRouter.of(context).pop(),
            ),
            actions: [
              Consumer2<ExerciseDetailViewModel, DiaryViewModel>(
                builder: (context, exerciseVM, diaryVM, child) {
                  final exercise = exerciseVM.exercise;

                  if (exerciseVM.loadState != LoadState.loaded || exercise == null) {
                    return const SizedBox.shrink();
                  }

                  final isAdding = diaryVM.isAddingExercise(exercise.id);

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
                      diaryVM.addExerciseToDiary(widget.workoutLogId, exerciseId: exercise.id, duration: widget.duration);
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: Consumer<ExerciseDetailViewModel>(
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
            'Loading exercise information...',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ExerciseDetailViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return const SizedBox.shrink();

    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(
    //         Icons.error_outline,
    //         size: 64,
    //         color: colorScheme.error,
    //       ),
    //       const SizedBox(height: 16),
    //       Text(
    //         'Failed to load food information',
    //         style: textTheme.titleMedium,
    //       ),
    //       const SizedBox(height: 8),
    //       Text(
    //         viewModel.errorMessage ?? 'Unknown error occurred',
    //         textAlign: TextAlign.center,
    //         style: textTheme.bodyMedium,
    //       ),
    //       const SizedBox(height: 24),
    //       ElevatedButton.icon(
    //         icon: const Icon(Icons.refresh),
    //         label: const Text('Try Again'),
    //         onPressed: () => viewModel.loadFood(widget.foodId),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildTimeoutState(
      BuildContext context, ExerciseDetailViewModel viewModel) {
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
            onPressed: () => viewModel.loadExercise(widget.exerciseId),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ExerciseDetailViewModel viewModel,
      TextTheme textTheme) {
    final exercise = viewModel.exercise;
    final colorScheme = Theme.of(context).colorScheme;

    if (exercise == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const CustomDivider(),
          ExerciseInfoSection(
            label: 'Duration',
            value: viewModel.duration.toString(),
            onTap: () => _editDuration(context, viewModel),
          ),
          const CustomDivider(),
          ExerciseInfoSection(
            label: 'Calories Burned Per Minute',
            value: exercise.caloriesBurnedPerMinute.toString(),
            //onTap: () => _selectServingUnit(context, viewModel),
            onTap: () => {},
          ),
          const CustomDivider(),
          const SizedBox(height: 16),
          // Row(
          //   children: [
          //     CalorieSummary(
          //       calories: food.calories,
          //       carbs: food.carbs,
          //       fat: food.fat,
          //       protein: food.protein,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  // Future<void> _selectMealType(
  //     BuildContext context, FoodDetailViewModel viewModel) async {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;
  //
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //         'Select Meal Type',
  //         style: textTheme.titleMedium,
  //       ),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             _buildMealTypeOption(
  //               context,
  //               MealType.breakfast,
  //               viewModel,
  //               Icons.wb_sunny_outlined,
  //             ),
  //             const SizedBox(height: 8),
  //             _buildMealTypeOption(
  //               context,
  //               MealType.lunch,
  //               viewModel,
  //               Icons.restaurant_outlined,
  //             ),
  //             const SizedBox(height: 8),
  //             _buildMealTypeOption(
  //               context,
  //               MealType.dinner,
  //               viewModel,
  //               Icons.nights_stay_outlined,
  //             ),
  //             const SizedBox(height: 8),
  //             _buildMealTypeOption(
  //               context,
  //               MealType.snack,
  //               viewModel,
  //               Icons.fastfood_outlined,
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(color: colorScheme.primary),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMealTypeOption(
  //   BuildContext context,
  //   MealType mealType,
  //   FoodDetailViewModel viewModel,
  //   IconData icon,
  // ) {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;
  //   final isSelected = viewModel.selectedMealType == mealType;
  //
  //   return InkWell(
  //     onTap: () {
  //       viewModel.updateMealType(mealType);
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? colorScheme.primary.withOpacity(0.1)
  //             : Colors.transparent,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(
  //           color: isSelected
  //               ? colorScheme.primary
  //               : colorScheme.outline.withOpacity(0.5),
  //           width: isSelected ? 2 : 1,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             icon,
  //             color: isSelected
  //                 ? colorScheme.primary
  //                 : colorScheme.onSurface.withOpacity(0.7),
  //           ),
  //           const SizedBox(width: 16),
  //           Text(
  //             _getMealTypeDisplayName(mealType),
  //             style: textTheme.bodyMedium?.copyWith(
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //               color: isSelected ? colorScheme.primary : colorScheme.onSurface,
  //             ),
  //           ),
  //           const Spacer(),
  //           if (isSelected)
  //             Icon(
  //               Icons.check_circle,
  //               color: colorScheme.primary,
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _selectServingUnit(
  //     BuildContext context, FoodDetailViewModel viewModel) async {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;
  //
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //         'Select Serving Unit',
  //         style: textTheme.titleMedium,
  //       ),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             for (var unit in viewModel.servingUnits) ...[
  //               _buildServingUnitOption(
  //                 context,
  //                 unit,
  //                 viewModel,
  //               ),
  //               const SizedBox(height: 8),
  //             ]
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(color: colorScheme.primary),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildServingUnitOption(
  //     BuildContext context,
  //     ServingUnit servingUnit,
  //     ExerciseDetailViewModel viewModel,
  //     ) {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;
  //   final isSelected = viewModel.selectedServingUnit?.id == servingUnit.id;
  //
  //   return InkWell(
  //     onTap: () {
  //       viewModel.updateServingUnit(servingUnit);
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? colorScheme.primary.withOpacity(0.1)
  //             : Colors.transparent,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(
  //           color: isSelected
  //               ? colorScheme.primary
  //               : colorScheme.outline.withOpacity(0.5),
  //           width: isSelected ? 2 : 1,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Text(
  //             '${servingUnit.unitName} (${servingUnit.unitSymbol})',
  //             style: textTheme.bodyMedium?.copyWith(
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //               color: isSelected ? colorScheme.primary : colorScheme.onSurface,
  //             ),
  //           ),
  //           const Spacer(),
  //           if (isSelected)
  //             Icon(
  //               Icons.check_circle,
  //               color: colorScheme.primary,
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _editDuration(
      BuildContext context, ExerciseDetailViewModel viewModel) async {
    final controller =
    TextEditingController(text: viewModel.duration.toString());
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Duration'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of duration',
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
              final newDuration = double.tryParse(controller.text);
              if (newDuration != null && newDuration >= 0) {
                viewModel.updateDuration(newDuration);
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
