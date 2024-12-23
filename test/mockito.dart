import 'package:mockito/mockito.dart';

class MockApiService extends Mock {
  Future<List<dynamic>> fetchAlerts() async {
    return [];
  }
}
