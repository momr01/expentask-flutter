import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:payments_management/features/home/services/home_services.dart';

class MockApiService extends Mock {
  Future<List<dynamic>> fetchAlerts() async {
    return [];
  }
}

@GenerateMocks([HomeServices])
void main() {} // requerido por mockito

