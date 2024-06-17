import 'package:json_annotation/json_annotation.dart';

part 'user_historical.g.dart';

@JsonSerializable()
class UserHistorical {
  final String id;
  final String email;
  final String name;
  final String type;

  UserHistorical({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
  });

  factory UserHistorical.fromJson(Map<String, dynamic> json) =>
      _$UserHistoricalFromJson(json);

  Map<String, dynamic> toJson() => _$UserHistoricalToJson(this);
}
