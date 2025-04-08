import '../../fitness/services/api_client.dart';
import '../models/dashboard.dart';

class DashboardApiService {
  final ApiClient apiClient;

  DashboardApiService(this.apiClient);

  Future<DashboardLogModel> fetchDashboardData(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await apiClient.get('api/dashboard', queryParams: null, headers: headers);

    return DashboardLogModel.fromJson(response);
  }
}
