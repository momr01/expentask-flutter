/*part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      dataEntry: stringToDateTime(json['dataEntry']),
      type: json['type'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'isActive': instance.isActive,
      'dataEntry': instance.dataEntry,
      'type': instance.type,
      'token': instance.token
    };
*/