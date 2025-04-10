import '../../models/diary.dart';
import '../api_client.dart';

class DiaryRepository {
  final ApiClient _apiClient;

  DiaryRepository({
    String baseUrl =
        "https://54efe02a-ae6e-4055-9391-3a9bd9cac8f1.mock.pstmn.io/api/diary",
  }) : _apiClient = ApiClient(baseUrl);

  final String jwtToken = "abc";

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

  String _formatDateForApi(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<Diary> getDiaryForDate(DateTime date) async {
    final formattedDate = _formatDateForApi(date);

    try {
      final response = await _apiClient.get("/", queryParams: {
        'date': formattedDate,
      });

      return Diary.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to load diary: $e');
    }
  }

  Future<void> addFoodToDiary(
      int diaryId, String foodId, int servings, DateTime date) async {
    // try {
    //   await _apiClient.post("/add_food", body: {
    //     "diary_id": diaryId,
    //     "food_id": foodId,
    //     "serving_size": servings,
    //     "date": date.toIso8601String()
    //   });
    // } catch (e) {
    //   throw Exception('Failed to add food to diary: $e');
    // }
  }
}
