import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/food.dart';
import '../services/repository/food_repository.dart';

class SearchFoodViewModel extends ChangeNotifier {
  final FoodRepository _repository;
  final List<Food> _foods = [];
  List<Food> _filteredFoods = [];

  // Thêm timeout cho API calls
  final Duration _timeout = const Duration(seconds: 15);

  SearchFoodViewModel({FoodRepository? repository})
      : _repository = repository ?? FoodRepository();

  List<Food> get foods => _foods;
  List<Food> get filteredFoods => _filteredFoods;

  bool isLoading = false;
  bool isFetchingMore = false;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _errorMessage = '';
  String _loadMoreError = '';

  bool get hasMoreData => _hasMoreData;
  String get errorMessage => _errorMessage;
  String get loadMoreError => _loadMoreError;

  Future<void> searchFoods({String query = '', int page = 1, int size = 10}) async {
    if (isLoading) return;

    // Reset error message
    _errorMessage = '';

    isLoading = true;
    _searchQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();

    try {
      // Thêm timeout cho request
      final newFoodsResult = await _fetchWithTimeout(
              () => _repository.searchFoods(query, page: page, size: size)
      );

      _foods.clear();
      _foods.addAll(newFoodsResult);
      _filteredFoods = List.from(_foods);

      if (newFoodsResult.length < size) {
        _hasMoreData = false;
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      debugPrint('Error fetching foods: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreFoods(int size) async {
    if (isFetchingMore || !_hasMoreData) return;

    // Reset load more error
    _loadMoreError = '';

    isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newFoodsResult = await _fetchWithTimeout(
              () => _repository.searchFoods(_searchQuery, page: _currentPage, size: size)
      );

      if (newFoodsResult.isEmpty) {
        _hasMoreData = false;
      } else {
        _foods.addAll(newFoodsResult);
        _filteredFoods = List.from(_foods);
      }
    } catch (e) {
      _loadMoreError = _getErrorMessage(e);
      _currentPage--; // Rollback page increment on error
      debugPrint('Error fetching more foods: $e');
    }

    isFetchingMore = false;
    notifyListeners();
  }

  // Helper method to add timeout to API calls
  Future<T> _fetchWithTimeout<T>(Future<T> Function() fetchFunction) async {
    try {
      return await fetchFunction().timeout(_timeout);
    } on TimeoutException {
      throw TimeoutException('Request timed out. Please check your connection and try again.');
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.toString().contains('HttpException')) {
      return 'Server error occurred. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  void filterFoods({String query = ''}) {
    _searchQuery = query;
    _filteredFoods = _foods
        .where((food) => food.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    notifyListeners();
  }
}