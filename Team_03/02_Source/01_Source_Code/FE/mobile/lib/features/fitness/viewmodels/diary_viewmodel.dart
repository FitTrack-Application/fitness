import 'package:flutter/cupertino.dart';
import 'package:mobile/features/fitness/services/repository/meal_log_repository.dart';
import 'package:mobile/features/fitness/services/repository/workout_log_repository.dart';

import '../models/exercise_entry.dart';
import '../models/meal_entry.dart';
import '../models/meal_log.dart';
import '../models/workout_log.dart';
import '../services/repository/food_repository.dart';

class DiaryViewModel extends ChangeNotifier {
  final MealLogRepository _mealLogRepository;
  final FoodRepository _foodRepository;
  final WorkoutLogRepository _workoutLogRepository;

  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  // #### Food ####
  // Thay thế biến isAdding bằng Set các foodIds đang được thêm
  final Set<String> _addingFoodIds = {};

  // Thêm set để theo dõi các món ăn đang được xóa
  final Set<String> _removingFoodIds = {};

  // #### Exercise ####
  WorkoutLogFitness? workoutLog;

  // Thay thế biến isAdding bằng Set các exerciseIds đang được thêm
  final Set<String> _addingExerciseIds = {};
  // Thêm set để theo dõi các bài tập đang được xóa
  final Set<String> _removingExerciseIds = {};

  String? errorMessage;
  List<MealLogFitness> mealLogs = [];
  List<ExerciseEntry> exerciseEntries = [];
  int calorieGoal = 0;
  int exerciseCalorieGoal = 0;

  DiaryViewModel() :
        _mealLogRepository = MealLogRepository(),
        _foodRepository = FoodRepository(),
        _workoutLogRepository = WorkoutLogRepository() {
    fetchDiaryForSelectedDate();
    fetchCaloriesGoal();
    //fetchExerciseCalorieGoal();
  }

  // Getters
  bool isAddingFood(String foodId) => _addingFoodIds.contains(foodId);

  // Getter để kiểm tra món ăn có đang được xóa không
  bool isRemovingFood(String foodId) => _removingFoodIds.contains(foodId);

  // Getters
  bool isAddingExercise(String exerciseId) => _addingExerciseIds.contains(exerciseId);

  // Getter để kiểm tra bài tập có đang được xóa không
  bool isRemovingExercise(String exerciseId) => _removingExerciseIds.contains(exerciseId);

  // Getters
  List<MealEntry> get breakfastEntries => mealLogs
      .where((log) => log.mealType == MealType.breakfast)
      .expand((log) => log.mealEntries)
      .toList();

  List<MealEntry> get lunchEntries => mealLogs
      .where((log) => log.mealType == MealType.lunch)
      .expand((log) => log.mealEntries)
      .toList();

  List<MealEntry> get dinnerEntries => mealLogs
      .where((log) => log.mealType == MealType.dinner)
      .expand((log) => log.mealEntries)
      .toList();

  List<MealEntry> get snackEntries => mealLogs
      .where((log) => log.mealType == MealType.snack)
      .expand((log) => log.mealEntries)
      .toList();

  double get breakfastCalories =>
      breakfastEntries.fold(0, (sum, entry) => sum + entry.food.calories);

  double get lunchCalories =>
      lunchEntries.fold(0, (sum, entry) => sum + entry.food.calories);

  double get dinnerCalories =>
      dinnerEntries.fold(0, (sum, entry) => sum + entry.food.calories);

  double get snackCalories =>
      snackEntries.fold(0, (sum, entry) => sum + entry.food.calories);


  double get caloriesConsumed =>
      breakfastCalories + lunchCalories + dinnerCalories + snackCalories;

  int get caloriesBurned => workoutLog?.totalCaloriesBurned ?? 0;

  double get caloriesRemaining => calorieGoal - caloriesConsumed + caloriesBurned;

  // Kiểm tra xem ngày đã chọn có phải là hôm nay không
  bool get isSelectedDateToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  /// Thay đổi ngày đã chọn
  Future<void> changeSelectedDate(DateTime date) async {
    selectedDate = date;
    await fetchDiaryForSelectedDate();
    notifyListeners();
  }

  /// Chuyển sang ngày hôm trước
  void goToPreviousDay() {
    changeSelectedDate(selectedDate.subtract(const Duration(days: 1)));
  }

  /// Chuyển sang ngày hôm sau
  void goToNextDay() {
    changeSelectedDate(selectedDate.add(const Duration(days: 1)));
  }

  /// Lấy dữ liệu nhật ký cho ngày đã chọn
  Future<void> fetchDiaryForSelectedDate() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Fetch workout log
      try {
        workoutLog = await _workoutLogRepository.fetchWorkoutLogForDate(selectedDate);
       // workoutLog ??= await _workoutLogRepository.createWorkoutLogForDate(selectedDate);
        exerciseEntries = workoutLog?.exerciseEntries ?? [];
      } catch (e) {
        print('Error fetching workout log: $e');
        workoutLog = null;
        exerciseEntries = [];
      }

      // Fetch meal logs
      try {
        mealLogs = await _mealLogRepository.fetchMealLogsForDate(selectedDate);
      } catch (e) {
        // Nếu lỗi là do không có meal log, thì tạo mới rồi fetch lại
        if (e.toString().contains('Failed to load meal logs: 400')) {
          await _mealLogRepository.createMealLogsForDate(selectedDate);
          mealLogs = await _mealLogRepository.fetchMealLogsForDate(selectedDate);
        } else {
          rethrow;
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Không thể tải dữ liệu: ${e.toString()}";
      notifyListeners();
    }
  }

  /// Thêm thức ăn vào nhật ký
  Future<void> addFoodToDiary({
    required String mealLogId,
    required String foodId,
    required String servingUnitId,
    required double numberOfServings,
  }) async {
    _addingFoodIds.add(foodId);
    notifyListeners();

    try {
      // Get default serving unit if not provided
      if (servingUnitId.isEmpty){
        final servingUnitList = await _foodRepository.getAllServingUnits();
        if (servingUnitList.isNotEmpty) {
          servingUnitId = servingUnitList.first.id;
        }
      }

      await _mealLogRepository.addMealEntryToLog(
          mealLogId: mealLogId,
          foodId: foodId,
          servingUnitId: servingUnitId,
          numberOfServings: numberOfServings);
      // Cập nhật lại diary sau khi thêm thành công
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể thêm thức ăn: ${e.toString()}";
      notifyListeners();
    } finally {
      // Xóa foodId khỏi danh sách đang xử lý
      _addingFoodIds.remove(foodId);
      notifyListeners();
    }
  }

  /// Xóa thức ăn khỏi nhật ký
  Future<void> removeFoodFromDiary(String mealEntryId) async {
    _removingFoodIds.add(mealEntryId);
    notifyListeners();

    try {
      await _mealLogRepository.deleteMealEntry(mealEntryId);

      // Cập nhật lại UI sau khi xóa thành công
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể xóa thức ăn: ${e.toString()}";
      notifyListeners();
    } finally {
      _removingFoodIds.remove(mealEntryId);
      notifyListeners();
    }
  }

  /// Edit meal entry in meal log
  Future<void> editFoodInDiary({
    required String mealEntryId,
    required String foodId,
    required String servingUnitId,
    required double numberOfServings,
  }) async {
    _addingFoodIds.add(mealEntryId); // Tạm dùng chung set để hiện trạng thái loading
    notifyListeners();

    try {
      await _mealLogRepository.editMealEntry(
        mealEntryId: mealEntryId,
        numberOfServings: numberOfServings,
        foodId: foodId,
        servingUnitId: servingUnitId,
      );

      // Cập nhật lại nhật ký sau khi chỉnh sửa
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể cập nhật món ăn: ${e.toString()}";
      notifyListeners();
    } finally {
      _addingFoodIds.remove(mealEntryId);
      notifyListeners();
    }
  }

  /// Thêm bài tập vào nhật ký
  Future<void> addExerciseToDiary(String? workoutLogId, {
    required String exerciseId,
    required double duration,

  }) async {
    _addingExerciseIds.add(exerciseId);
    notifyListeners();

    try {
      // Kiểm tra xem đã có workout log cho ngày này chưa
      workoutLog ??= await _workoutLogRepository.createWorkoutLogForDate(selectedDate);

      await _workoutLogRepository.addExerciseEntry(
        workoutLogId: workoutLog!.id,
        exerciseId: exerciseId,
        duration: duration,
      );

      // Cập nhật lại diary sau khi thêm thành công
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể thêm bài tập: ${e.toString()}";
      notifyListeners();
    } finally {
      // Xóa exerciseId khỏi danh sách đang xử lý
      _addingExerciseIds.remove(exerciseId);
      notifyListeners();
    }
  }

  /// Xóa bài tập khỏi nhật ký
  Future<void> removeExerciseFromDiary(String exerciseEntryId) async {
    _removingExerciseIds.add(exerciseEntryId);
    notifyListeners();

    try {
      await _workoutLogRepository.deleteExerciseEntry(exerciseEntryId);

      // Cập nhật lại UI sau khi xóa thành công
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể xóa bài tập: ${e.toString()}";
      notifyListeners();
    } finally {
      _removingExerciseIds.remove(exerciseEntryId);
      notifyListeners();
    }
  }

  /// Chỉnh sửa bài tập trong nhật ký
  Future<void> editExerciseInDiary({
    required String exerciseEntryId,
    required String exerciseId,
    required int duration,
  }) async {
    _addingExerciseIds.add(exerciseEntryId); // Tạm dùng chung set để hiện trạng thái loading
    notifyListeners();

    try {
      await _workoutLogRepository.editExerciseEntry(
        exerciseEntryId: exerciseEntryId,
        exerciseId: exerciseId,
        duration: duration,
      );

      // Cập nhật lại nhật ký sau khi chỉnh sửa
      await fetchDiaryForSelectedDate();
    } catch (e) {
      errorMessage = "Không thể cập nhật bài tập: ${e.toString()}";
      notifyListeners();
    } finally {
      _addingExerciseIds.remove(exerciseEntryId);
      notifyListeners();
    }
  }

  Future<void> fetchCaloriesGoal() async {
    try {
      calorieGoal = await _mealLogRepository.fetchCaloriesGoal();
      notifyListeners();
    } catch (e) {
      errorMessage = "Không thể lấy calorie goal: ${e.toString()}";
      notifyListeners();
    }
  }
}
