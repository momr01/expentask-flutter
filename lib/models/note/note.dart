import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String? id;
  final String title;
  final String content;
  final String dataEntry;
  final bool isActive;
  final String? associatedType;
  final String? associatedValue;

  Note(
      {this.id,
      required this.title,
      required this.content,
      required this.dataEntry,
      required this.isActive,
      this.associatedType,
      this.associatedValue});

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
