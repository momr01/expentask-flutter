// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Alert {
  final String paymentId;
  final String paymentName;
  final String taskId;
  final String taskCode;
  final String taskName;
  final DateTime taskDeadline;
  final bool taskIsActive;
  final bool taskIsCompleted;
  final int daysNumber;
  final bool hasInstallments;

  Alert(
      {required this.paymentId,
      required this.paymentName,
      required this.taskId,
      required this.taskCode,
      required this.taskName,
      required this.taskDeadline,
      required this.taskIsActive,
      required this.taskIsCompleted,
      required this.daysNumber,
      required this.hasInstallments});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentId': paymentId,
      'paymentName': paymentName,
      'taskId': taskId,
      'taskCode': taskCode,
      'taskName': taskName,
      'taskDeadline': taskDeadline,
      'taskIsActive': taskIsActive,
      'taskIsCompleted': taskIsCompleted,
      'daysNumber': daysNumber,
      'hasInstallments': hasInstallments
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      paymentId: map['paymentId'] as String,
      paymentName: map['paymentName'] as String,
      taskId: map['taskId'] as String,
      taskCode: map['taskCode'] as String,
      taskName: map['taskName'] as String,
      taskDeadline: DateTime.parse(map['taskDeadline']),
      taskIsActive: map['taskIsActive'] as bool,
      taskIsCompleted: map['taskIsCompleted'] as bool,
      daysNumber: map['daysNumber'] as int,
      hasInstallments: map['hasInstallments'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Alert.fromJson(String source) =>
      Alert.fromMap(json.decode(source) as Map<String, dynamic>);
}
