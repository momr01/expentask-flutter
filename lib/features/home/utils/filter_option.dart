import 'package:payments_management/models/payment/payment.dart';

class FilterOption {
  final int id;
  final String name;
  final String type;
  bool state;
  final List<Payment> Function(List<Payment>, String)
      filter; // Función de filtrado
  // final Future<List<Payment>> Function(List<Payment>)
  //  filter; // Función de filtrado

  FilterOption({
    required this.id,
    required this.name,
    required this.type,
    required this.state,
    required this.filter, // Ahora se requiere una función de filtrado
  });
}
