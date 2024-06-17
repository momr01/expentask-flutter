class TaskEdit {
  final String code;
  final String deadline;

  TaskEdit({required this.code, required this.deadline});

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'code': code,
  //     'deadline': deadline,
  //   };
  // }

  // factory TaskEdit.fromMap(Map<String, dynamic> map) {
  //   return TaskEdit(
  //     code: map['code'] as String,
  //     deadline: map['deadline'] as String,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory TaskEdit.fromJson(String source) =>
  //     TaskEdit.fromMap(json.decode(source) as Map<String, dynamic>);
}
