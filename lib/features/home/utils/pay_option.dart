class PayOption {
  final String id;
  final String code;
  final String label;
  bool state;

  PayOption(
      {required this.id,
      required this.code,
      required this.label,
      required this.state});
}
