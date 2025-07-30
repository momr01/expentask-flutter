import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

class PaymentNote {
  final String id;
  final String name;
  final String period;

  PaymentNote({required this.id, required this.name, required this.period});

  factory PaymentNote.fromJson(Map<String, dynamic> json) => PaymentNote(
        id: json['id'] as String,
        name: json['name'] as String,
        period: json['period'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'period': period,
      };
}

class NameNote {
  final String id;
  final String name;

  NameNote({required this.id, required this.name});

  factory NameNote.fromJson(Map<String, dynamic> json) => NameNote(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

@JsonSerializable()
class Note {
  final String? id;
  final String title;
  final String content;
  final String dataEntry;
  final bool isActive;
  final String? associatedType;
  final String? associatedValue;
  final PaymentNote? payment;
  final NameNote? name;

  Note(
      {this.id,
      required this.title,
      required this.content,
      required this.dataEntry,
      required this.isActive,
      this.associatedType,
      this.associatedValue,
      this.name,
      this.payment});

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
