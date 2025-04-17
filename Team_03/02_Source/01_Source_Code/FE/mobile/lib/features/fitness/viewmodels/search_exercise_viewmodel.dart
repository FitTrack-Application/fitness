// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import '../models/exercise.dart';
// import '../services/repository/exercise_repository.dart';
//
// class SearchExerciseViewModel extends ChangeNotifier {
//   final ExerciseRepository _repository;
//   final List<Exercise> _exercises = [];
//
//   // Timeout for API calls
//   final Duration _timeout = const Duration(seconds: 15);
//
//   SearchExerciseViewModel({ExerciseRepository? repository})
//       : _repository = repository ?? ExerciseRepository();
//
//   List<Exercise> get exercises => _exercises;
//
//   bool isLoading = false;
//   bool isFetchingMore = false;
//   String _searchQuery = '';
//   int _currentPage = 1;
//   int _totalPages = 1;
//   bool _hasMoreData = true;
//   String _errorMessage = '';
//   String _loadMoreError = '';
//
//   bool get hasMoreData => _hasMoreData;
//   String get errorMessage => _errorMessage;
//   String get loadMoreError => _loadMoreError;
//
//   Future<void> searchExercises({String query = '', bool isMyExercise = false}) async {
//     if (isLoading) return;
//
//     // Reset error message
//     _errorMessage = '';
//     isLoading = true;
//     _searchQuery = query;
//     _currentPage = 1;
//     _hasMoreData = true;
//     notifyListeners();
//
//     try {
//       final paginatedResponse = await _fetchWithTimeout(
//               () => isMyExercise
//               ? _repository.searchMyExercises(query, page: _currentPage, size: 10)
//               : _repository.searchExercises(query, page: _currentPage, size: 10));
//
//       _exercises.clear();
//       _exercises.addAll(paginatedResponse.data);
//
//       _currentPage = paginatedResponse.pagination.currentPage;
//       _totalPages = paginatedResponse.pagination.totalPages;
//       _hasMoreData = _currentPage < _totalPages;
//     } catch (e) {
//       _errorMessage = _getErrorMessage(e);
//       debugPrint('Error fetching exercises: $e');
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> loadMoreExercises({int size = 10, bool isMyExercise = false}) async {
//     if (isFetchingMore || !_hasMoreData) return;
//
//     _loadMoreError = '';
//     isFetchingMore = true;
//     notifyListeners();
//
//     try {
//       _currentPage++;
//       final paginatedResponse = await _fetchWithTimeout(() => isMyExercise
//           ? _repository.searchMyExercises(_searchQuery, page: _currentPage, size: size)
//           : _repository.searchExercises(_searchQuery, page: _currentPage, size: size));
//
//       if (paginatedResponse.data.isEmpty) {
//         _hasMoreData = false;
//       } else {
//         _exercises.addAll(paginatedResponse.data);
//         _totalPages = paginatedResponse.pagination.totalPages;
//         _hasMoreData = _currentPage < _totalPages;
//       }
//     } catch (e) {
//       _loadMoreError = _getErrorMessage(e);
//       _currentPage--;
//       debugPrint('Error fetching more exercises: $e');
//     }
//
//     isFetchingMore = false;
//     notifyListeners();
//   }
//
//   // Helper method to add timeout to API calls
//   Future<T> _fetchWithTimeout<T>(Future<T> Function() fetchFunction) async {
//     try {
//       return await fetchFunction().timeout(_timeout);
//     } on TimeoutException {
//       throw TimeoutException(
//           'Request timed out. Please check your connection and try again.');
//     }
//   }
//
//   // Helper method to get user-friendly error messages
//   String _getErrorMessage(dynamic error) {
//     if (error is TimeoutException) {
//       return 'Request timed out. Please check your connection and try again.';
//     } else if (error.toString().contains('SocketException') ||
//         error.toString().contains('Connection refused')) {
//       return 'Unable to connect to the server. Please check your internet connection.';
//     } else if (error.toString().contains('HttpException')) {
//       return 'Server error occurred. Please try again later.';
//     } else {
//       return 'An unexpected error occurred. Please try again.';
//     }
//   }
// }