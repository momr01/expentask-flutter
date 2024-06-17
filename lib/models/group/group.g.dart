part of 'group.dart';

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    dataEntry: DateTime.parse(json['dataEntry']),
    isActive: json['isActive'] as bool,
    paymentNames: List<PaymentName>.from(
        (json['paymentNames']?.map((x) => PaymentName.fromJson(x)))));

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
      'paymentNames': instance.paymentNames,
    };
