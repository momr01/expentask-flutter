class GeneratePayment {
  final String id;
  final String name;
  bool state;

  GeneratePayment({required this.id, required this.name, required this.state});

  factory GeneratePayment.fromJson(Map<String, dynamic> json) {
    return GeneratePayment(
        id: json['id'], name: json['name'], state: json['state']);
  }
}
