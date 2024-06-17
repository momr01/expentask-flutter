part of 'payment_name.dart';

PaymentName _$PaymentNameFromJson(Map<String, dynamic> json) => PaymentName(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    isActive: json['isActive'] as bool,
    category: Category.fromJson(json['category'][0]),
    // defaultTasks:
    //     json['defaultTasks'] == null ? [] : json['defaultTasks'] as List<String>
    defaultTasks: json['defaultTasks'] == null
        ? []
        : List<String>.from((json['defaultTasks']?.map((task) => task))));

Map<String, dynamic> _$PaymentNameToJson(PaymentName instance) =>
    <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'isActive': instance.isActive,
      'category': instance.category,
      'defaultTasks': instance.defaultTasks?.toList()
    };
