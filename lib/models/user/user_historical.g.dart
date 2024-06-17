part of 'user_historical.dart';

UserHistorical _$UserHistoricalFromJson(Map<String, dynamic> json) =>
    UserHistorical(
      id: json['_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$UserHistoricalToJson(UserHistorical instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'type': instance.type
    };
