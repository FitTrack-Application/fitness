import '../../fitness/services/api_client.dart';
import '../models/dashboard.dart';
import '../models/weight_entry.dart';
class DashboardApiService {
  final ApiClient apiClient;

  DashboardApiService(this.apiClient);

  Future<DashboardLogModel> fetchDashboardData(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await apiClient.get('api/dashboard', queryParams: null, headers: headers);

    return DashboardLogModel.fromJson(response);
  }

  Future<List<WeightEntry>> fetchWeightStatistics(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await apiClient.get('api/weight/statistic', queryParams: null, headers: headers);
    // Parse the response into a list of WeightEntry objects
    final List<dynamic> data = response['data']; // Assuming the response contains a 'data' field
    return data.map((entry) => WeightEntry.fromJson(entry)).toList();
  }
}
