import 'package:flutter/cupertino.dart';

import '../models/diary.dart';
import '../models/exercise.dart';
import '../models/food.dart';
import '../services/repository/diary_repository.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository _repository;

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  // Thay thế biến isAdding bằng Set các foodIds đang được thêm
  final Set<String> _addingFoodIds = {};
  // Thêm set để theo dõi các món ăn đang được xóa
  final Set<String> _removingFoodIds = {};
  Diary? _currentDiaryDay;
  String? _errorMessage;

  DiaryViewModel() : _repository = DiaryRepository() {
    fetchDiaryForSelectedDate();
  }

  // Getters
  bool isAddingFood(String foodId) => _addingFoodIds.contains(foodId);

  // Getter để kiểm tra món ăn có đang được xóa không
  bool isRemovingFood(String foodId) => _removingFoodIds.contains(foodId);

  // Getters
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mảng thực phẩm cho từng bữa ăn
  List<Food> get breakfastItems => _currentDiaryDay?.foodItems
      .where((food) => food.mealType == MealType.Breakfast)
      .toList() ?? [];

  List<Food> get lunchItems => _currentDiaryDay?.foodItems
      .where((food) => food.mealType == MealType.Lunch)
      .toList() ?? [];

  List<Food> get dinnerItems => _currentDiaryDay?.foodItems
      .where((food) => food.mealType == MealType.Dinner)
      .toList() ?? [];

  List<Food> get foodItems => _currentDiaryDay?.foodItems ?? [];
  List<Exercise> get exerciseItems => _currentDiaryDay?.exerciseItems ?? [];
  int get calorieGoal => _currentDiaryDay?.calorieGoal ?? 0;

  // Calo tiêu thụ theo từng bữa
  double get breakfastCalories => breakfastItems.fold(0, (sum, item) => sum + item.calories);
  double get lunchCalories => lunchItems.fold(0, (sum, item) => sum + item.calories);
  double get dinnerCalories => dinnerItems.fold(0, (sum, item) => sum + item.calories);

  double get caloriesConsumed => _currentDiaryDay?.caloriesConsumed ?? 0;
  double get caloriesBurned => _currentDiaryDay?.caloriesBurned ?? 0;
  double get caloriesRemaining => _currentDiaryDay?.caloriesRemaining ?? 0;
  int get diaryId => _currentDiaryDay?.diaryId ?? 0;

  // Kiểm tra xem ngày đã chọn có phải là hôm nay không
  bool get isSelectedDateToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  /// Thay đổi ngày đã chọn
  void changeSelectedDate(DateTime date) {
    _selectedDate = date;
    fetchDiaryForSelectedDate();
    notifyListeners();
  }

  /// Chuyển sang ngày hôm trước
  void goToPreviousDay() {
    changeSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
  }

  /// Chuyển sang ngày hôm sau
  void goToNextDay() {
    changeSelectedDate(_selectedDate.add(const Duration(days: 1)));
  }

  /// Lấy dữ liệu nhật ký cho ngày đã chọn
  Future<void> fetchDiaryForSelectedDate() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final diary = await _repository.getDiaryForDate(_selectedDate);
      _currentDiaryDay = diary;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Không thể tải dữ liệu: ${e.toString()}";
      notifyListeners();
    }
  }

  /// Thêm thức ăn vào nhật ký
  Future<void> addFoodToDiary(Food food, int servingSize, DateTime date) async {
    _addingFoodIds.add(food.id);
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await _repository.addFoodToDiary(diaryId, food.id, servingSize, date);
      // Cập nhật lại diary sau khi thêm thành công
      await fetchDiaryForSelectedDate();
    } catch (e) {
      _errorMessage = "Không thể thêm thức ăn: ${e.toString()}";
      notifyListeners();
    } finally {
      // Xóa foodId khỏi danh sách đang xử lý
      _addingFoodIds.remove(food.id);
      notifyListeners();
    }
  }

  /// Xóa thức ăn khỏi nhật ký
  Future<void> removeFoodFromDiary(String foodId) async {
    _removingFoodIds.add(foodId);
    notifyListeners();

    try {
      await _repository.removeFoodFromDiary(diaryId, foodId, _selectedDate);

      // Cập nhật lại UI sau khi xóa thành công
      if (_currentDiaryDay != null) {
        // Tạo Diary mới với danh sách món ăn đã được cập nhật
        final updatedFoodItems = _currentDiaryDay!.foodItems
            .where((food) => food.id != foodId)
            .toList();

        _currentDiaryDay = Diary(
          diaryId: _currentDiaryDay!.diaryId,
          date: _currentDiaryDay!.date,
          calorieGoal: _currentDiaryDay!.calorieGoal,
          foodItems: updatedFoodItems,
          exerciseItems: _currentDiaryDay!.exerciseItems,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = "Không thể xóa thức ăn: ${e.toString()}";
      notifyListeners();
    } finally {
      _removingFoodIds.remove(foodId);
      notifyListeners();
    }
  }
}