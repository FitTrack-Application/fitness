import 'package:flutter/cupertino.dart';
import 'package:mobile/features/fitness/services/repository/meal_log_repository.dart';

import '../models/exercise.dart';
import '../models/food.dart';
import '../models/meal_log.dart';

class DiaryViewModel extends ChangeNotifier {
  final MealLogRepository _repository;

  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  // Thay thế biến isAdding bằng Set các foodIds đang được thêm
  final Set<String> _addingFoodIds = {};
  // Thêm set để theo dõi các món ăn đang được xóa
  final Set<String> _removingFoodIds = {};
  String? errorMessage;
  List<MealLogFitness> mealLogs = [];
  List<Exercise> exerciseItems = [];
  int calorieGoal = 5000;

  DiaryViewModel() : _repository = MealLogRepository() {
    fetchDiaryForSelectedDate();
  }

  // Getters
  bool isAddingFood(String foodId) => _addingFoodIds.contains(foodId);

  // Getter để kiểm tra món ăn có đang được xóa không
  bool isRemovingFood(String foodId) => _removingFoodIds.contains(foodId);

  // Getters
  // Mảng thực phẩm cho từng bữa ăn
  List<Food> get breakfastItems => mealLogs
      .where((log) => log.mealType == MealType.breakfast)
      .expand((log) => log.mealEntries)
      .map((entry) => entry.food)
      .toList();

  List<Food> get lunchItems => mealLogs
      .where((log) => log.mealType == MealType.lunch)
      .expand((log) => log.mealEntries)
      .map((entry) => entry.food)
      .toList();

  List<Food> get dinnerItems => mealLogs
      .where((log) => log.mealType == MealType.dinner)
      .expand((log) => log.mealEntries)
      .map((entry) => entry.food)
      .toList();

  // Calo tiêu thụ theo từng bữa
  double get breakfastCalories => breakfastItems.fold(0, (sum, item) => sum + item.calories);
  double get lunchCalories => lunchItems.fold(0, (sum, item) => sum + item.calories);
  double get dinnerCalories => dinnerItems.fold(0, (sum, item) => sum + item.calories);

  double get caloriesConsumed => breakfastCalories + lunchCalories + dinnerCalories;
  double get caloriesBurned =>
      exerciseItems.fold(0, (sum, exercise) => sum + exercise.calories.toDouble());
  double get caloriesRemaining => 5000 - caloriesConsumed + caloriesBurned;

  // Kiểm tra xem ngày đã chọn có phải là hôm nay không
  bool get isSelectedDateToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  /// Thay đổi ngày đã chọn
  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    fetchDiaryForSelectedDate();
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
      // TODO: Call API to fetch exercises
      exerciseItems = [];
      mealLogs = await _repository.fetchMealLogsForDate(selectedDate);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Không thể tải dữ liệu: ${e.toString()}";
      notifyListeners();
    }
  }

  /// Thêm thức ăn vào nhật ký
  Future<void> addFoodToDiary(Food food, int servingSize, DateTime date) async {
    // _addingFoodIds.add(food.id);
    // notifyListeners();
    //
    // try {
    //   await Future.delayed(const Duration(milliseconds: 500));
    //   await _repository.addFoodToDiary(diaryId, food.id, servingSize, date);
    //   // Cập nhật lại diary sau khi thêm thành công
    //   await fetchDiaryForSelectedDate();
    // } catch (e) {
    //   _errorMessage = "Không thể thêm thức ăn: ${e.toString()}";
    //   notifyListeners();
    // } finally {
    //   // Xóa foodId khỏi danh sách đang xử lý
    //   _addingFoodIds.remove(food.id);
    //   notifyListeners();
    // }
  }

  /// Xóa thức ăn khỏi nhật ký
  Future<void> removeFoodFromDiary(String foodId) async {
    // _removingFoodIds.add(foodId);
    // notifyListeners();
    //
    // try {
    //   await _repository.removeFoodFromDiary(diaryId, foodId, _selectedDate);
    //
    //   // Cập nhật lại UI sau khi xóa thành công
    //   if (_currentDiaryDay != null) {
    //     // Tạo Diary mới với danh sách món ăn đã được cập nhật
    //     final updatedFoodItems = _currentDiaryDay!.foodItems
    //         .where((food) => food.id != foodId)
    //         .toList();
    //
    //     _currentDiaryDay = Diary(
    //       diaryId: _currentDiaryDay!.diaryId,
    //       date: _currentDiaryDay!.date,
    //       calorieGoal: _currentDiaryDay!.calorieGoal,
    //       foodItems: updatedFoodItems,
    //       exerciseItems: _currentDiaryDay!.exerciseItems,
    //     );
    //   }
    //
    //   notifyListeners();
    // } catch (e) {
    //   _errorMessage = "Không thể xóa thức ăn: ${e.toString()}";
    //   notifyListeners();
    // } finally {
    //   _removingFoodIds.remove(foodId);
    //   notifyListeners();
    // }
  }
}