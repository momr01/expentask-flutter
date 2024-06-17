part of 'category.dart';

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    isActive: json['isActive'] as bool);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'isActive': instance.isActive,
    };
