import 'package:flutter/cupertino.dart';
import '../models/food.dart';
import '../models/serving_unit.dart';
import '../services/repository/food_repository.dart';

class CreateFoodViewmodel extends ChangeNotifier {
  final FoodRepository _repository;

  CreateFoodViewmodel(this._repository);
  List<ServingUnit> _servingUnits = [];
  ServingUnit? _selectedUnit;
  bool _isLoadingUnits = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController numberOfServingsController = TextEditingController();



  List<ServingUnit> get servingUnits => _servingUnits;
  ServingUnit? get selectedUnit => _selectedUnit;
  bool get isLoadingUnits => _isLoadingUnits;


  void setSelectedUnit(ServingUnit? unit) {
    if (unit != null) {
      _selectedUnit = unit;
      notifyListeners();
    }
  }
  Future<void> loadServingUnits() async {
    _isLoadingUnits = true;
    notifyListeners();

    try {
      _servingUnits = await _repository.getAllServingUnits();
      // Select the first unit or default one that exists in the list
      if (_servingUnits.isNotEmpty) {
        _selectedUnit = _servingUnits.first;
      }
    } catch (e) {
      // Optionally log or handle the error
    } finally {
      _isLoadingUnits = false;
      notifyListeners();
    }
  }

  Future<Food?> createFood() async {
    final name = nameController.text.trim();
    final calories = double.tryParse(caloriesController.text.trim())??0;
    final protein = double.tryParse(proteinController.text.trim())??0;
    final carb = double.tryParse(carbController.text.trim())??0;
    final fat = double.tryParse(fatController.text.trim())??0;
    final numberOfServings = double.tryParse(numberOfServingsController.text.trim())??0;

    if (name.isEmpty || calories == 0 || numberOfServings == 0|| selectedUnit == null )  return null;
    final newFood = Food(
      id: UniqueKey().toString(),
      name: name,
      calories: calories,
      protein: protein,
      carbs: carb,
      fat: fat,
      servingUnit: selectedUnit!,
      imageUrl: '',
      numberOfServings: numberOfServings,
    );

    try {
      final created = await _repository.createFood(newFood);
      return created;
    } catch (e) {
      return null;
    }
  }

  void disposeControllers() {
    nameController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

}

