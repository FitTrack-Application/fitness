import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/food.dart';
import '../services/repository/food_repository.dart';

class SearchFoodViewModel extends ChangeNotifier {
  final FoodRepository _repository;
  final List<Food> _foods = [];

  // Timeout for API calls
  final Duration _timeout = const Duration(seconds: 15);

  SearchFoodViewModel({FoodRepository? repository})
      : _repository = repository ?? FoodRepository();

  List<Food> get foods => _foods;

  bool isLoading = false;
  bool isFetchingMore = false;
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;
  String _errorMessage = '';
  String _loadMoreError = '';

  bool get hasMoreData => _hasMoreData;
  String get errorMessage => _errorMessage;
  String get loadMoreError => _loadMoreError;

  // Thêm `isMyFood` để phân biệt tìm kiếm các loại food
  Future<void> searchFoods({String query = '', bool isMyFood = false}) async {
    if (isLoading) return;

    // Reset error message
    _errorMessage = '';
    isLoading = true;
    _searchQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();

    try {
      final paginatedResponse = await _fetchWithTimeout(
              () => isMyFood
              ? _repository.searchMyFoods(query, page: _currentPage, size: 10)
              : _repository.searchFoods(query, page: _currentPage, size: 10));

      _foods.clear();
      _foods.addAll(paginatedResponse.data);

      _currentPage = paginatedResponse.pagination.currentPage;
      _totalPages = paginatedResponse.pagination.totalPages;
      _hasMoreData = _currentPage < _totalPages;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      debugPrint('Error fetching foods: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Cập nhật loadMoreFoods để sử dụng cho "My Food" khi cần
  Future<void> loadMoreFoods({int size = 10, bool isMyFood = false}) async {
    if (isFetchingMore || !_hasMoreData) return;

    _loadMoreError = '';
    isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final paginatedResponse = await _fetchWithTimeout(() => isMyFood
          ? _repository.searchMyFoods(_searchQuery, page: _currentPage, size: size)
          : _repository.searchFoods(_searchQuery, page: _currentPage, size: size));

      if (paginatedResponse.data.isEmpty) {
        _hasMoreData = false;
      } else {
        _foods.addAll(paginatedResponse.data);
        _totalPages = paginatedResponse.pagination.totalPages;
        _hasMoreData = _currentPage < _totalPages;
      }
    } catch (e) {
      _loadMoreError = _getErrorMessage(e);
      _currentPage--;
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
      throw TimeoutException(
          'Request timed out. Please check your connection and try again.');
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
}
