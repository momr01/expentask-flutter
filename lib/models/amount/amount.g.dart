part of 'amount.dart';

Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
    id: json['_id'] == null ? null : json['_id'] as String,
    description: json['description'] as String,
    // dataEntry: DateTime.parse(json['dataEntry']),
    amount: double.parse(json['amount']),
    date: DateTime.parse(json['date']),
    dataEntry: json['dataEntry'] as String,
    isActive: json['isActive'] as bool,
    payment: json['payment'] as String);

Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'description': instance.description,
      'date': instance.date,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
      'payment': instance.payment,
    };
