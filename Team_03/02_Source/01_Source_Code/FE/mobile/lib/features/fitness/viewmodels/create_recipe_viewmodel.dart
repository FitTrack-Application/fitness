import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/food.dart';
import '../models/recipe.dart';
import '../models/serving_unit.dart';
import '../services/repository/recipe_repository.dart';

class CreateRecipeViewModel extends ChangeNotifier {
  final RecipeRepository _repository;

  CreateRecipeViewModel(this._repository);
  final List<Food> _selectedFoods = [];
  List<ServingUnit> _servingUnits = [];
  ServingUnit? _selectedUnit;
  bool _isLoadingUnits = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfServingsController = TextEditingController();

  List<Food> get selectedFoods => _selectedFoods;
  List<ServingUnit> get servingUnits => _servingUnits;
  ServingUnit? get selectedUnit => _selectedUnit;
  bool get isLoadingUnits => _isLoadingUnits;


  void addFood(Food food) {
    _selectedFoods.add(food);
    notifyListeners();
  }

  void removeFood(Food food) {
    _selectedFoods.remove(food);
    notifyListeners();
  }

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


  Future<Recipe?> createRecipe() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final numberOfServings = double.tryParse(numberOfServingsController.text.trim()) ?? double.nan;

    if (name.isEmpty ||numberOfServings.isNaN|| description.isEmpty || selectedUnit == null )  return null;

    final newRecipe = Recipe(
      id: UniqueKey().toString(),
      name: name,
      description: description,
      numberOfServings: numberOfServings,
      servingUnit: _selectedUnit!,
      foodList: List.from(_selectedFoods),
    );

    try {
      final created = await _repository.createRecipe(newRecipe);
      return created;
    } catch (e) {
      return null;
    }
  }

  void disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

ServingUnit defaultUnit(){
  return ServingUnit(id: '9b0f9cf0-1c6e-4c1e-a3a1-8a9fddc20a0ba', unitName: 'Gam', unitSymbol: 'G');
}
