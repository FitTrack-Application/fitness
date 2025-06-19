import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/services/repository/exercise_repository.dart';
import 'package:mobile/features/fitness/view/exercises/widget/exercise_info_section.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/exercise_add_viewmodel.dart';
import '../food_detail/widget/custom_divider.dart';

class ExerciseAddScreen extends StatefulWidget {
  final String exerciseId;
  final String workoutLogId;
  final double duration;

  const ExerciseAddScreen({
    super.key,
    this.exerciseId = '',
    this.workoutLogId = '',
    this.duration = 0,
  });

  @override
  State<StatefulWidget> createState() => _ExerciseAddScreenState();
}

class _ExerciseAddScreenState extends State<ExerciseAddScreen> {
  late final ExerciseAddViewModel _exerciseVM;

  @override
  void initState() {
    super.initState();
    _exerciseVM = ExerciseAddViewModel(ExerciseRepository());
      // ..loadExercise(widget.exerciseId, duration: widget.duration);
    // _exerciseVM.duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<ExerciseAddViewModel>.value(
      value: _exerciseVM,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Create Your Exercise',
              style: textTheme.titleMedium,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => GoRouter.of(context).pop(),
            ),
            actions: [
              Consumer<ExerciseAddViewModel>(
                builder: (context, exerciseVM, child) {

                  return IconButton(
                    icon: Icon(Icons.check, color: colorScheme.primary),
                    onPressed: () async {
                      exerciseVM.createMyExercise();
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: Consumer<ExerciseAddViewModel>(
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
                  return _buildLoadedState(context, viewModel, textTheme);
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

  Widget _buildErrorState(BuildContext context, ExerciseAddViewModel viewModel) {
    return const SizedBox.shrink();
  }

  Widget _buildTimeoutState(
      BuildContext context, ExerciseAddViewModel viewModel) {
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
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.refresh),
          //   label: const Text('Try Again'),
          //   onPressed: () => viewModel.loadExercise(widget.exerciseId),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ExerciseAddViewModel viewModel,
      TextTheme textTheme) {
    //final exercise = viewModel.exercise;
    final colorScheme = Theme.of(context).colorScheme;

    // if (exercise == null) {
    //   return const SizedBox.shrink();
    // }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.name,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ExerciseInfoSection(
            label: 'Name',
            value: viewModel.name,
            onTap: () => _editName(context, viewModel),
          ),
          const CustomDivider(),
          ExerciseInfoSection(
            label: 'Duration',
            value: viewModel.duration.toString(),
            onTap: () => _editDuration(context, viewModel),
          ),
          const CustomDivider(),
          ExerciseInfoSection(
            label: 'Calories Burned Per Minute',
            value: viewModel.caloriesBurned.toString(),
            onTap: () => _editCaloriesBurned(context, viewModel),
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

  Future<void> _editDuration(
      BuildContext context, ExerciseAddViewModel viewModel) async {
    final controller =
    TextEditingController(text: viewModel.duration.toString());
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duration'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of duration',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                viewModel.duration = newDuration;
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

  Future<void> _editName(
      BuildContext context, ExerciseAddViewModel viewModel) async {
    final controller =
    TextEditingController(text: viewModel.name);
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exercise Name'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            LengthLimitingTextInputFormatter(50),
          ],
          decoration: InputDecoration(
            hintText: 'Enter exercise name',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error),
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
              final newName = controller.text;
              if (newName.trim().isNotEmpty) {
                viewModel.name = newName;
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

  Future<void> _editCaloriesBurned(
      BuildContext context, ExerciseAddViewModel viewModel) async {
    final controller =
    TextEditingController(text: viewModel.caloriesBurned.toString());
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calories Burned Per Minute'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of calories',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
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
              final newCaloriesBurned = int.tryParse(controller.text);
              if (newCaloriesBurned! > 0) {
                viewModel.caloriesBurned = newCaloriesBurned;
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
