import 'package:flutter/material.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/notes/services/notes_services.dart';
import 'package:payments_management/features/notes/widgets/modal_selection_list.dart';
import 'package:payments_management/models/note/note.dart';

class ModalAddEditNote extends StatefulWidget {
  final Note? note;
  final String? hasAssocType;
  final String? hasAssocValue;
  final String? hasAssocName;
  const ModalAddEditNote(
      {super.key,
      this.note,
      this.hasAssocType,
      this.hasAssocValue,
      this.hasAssocName});

  @override
  State<ModalAddEditNote> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<ModalAddEditNote> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isAssociated = false;
  String? _assocType;
  String? _assocValue;
  String? _assocName;
  final NotesServices notesServices = NotesServices();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _nameController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      if (widget.note!.associatedType != null) {
        _isAssociated = true;
        _assocType = widget.note!.associatedType;
        _assocValue = widget.note!.associatedValue;
      }
    }

    ////////////////////////////

    if (widget.hasAssocType != null) {
      if (widget.hasAssocType == "PAGO") {
        _isAssociated = true;
        _assocType = "PAGO";
        _assocValue = widget.hasAssocValue!;
        _assocName = widget.hasAssocName;
      } else {
        _isAssociated = true;
        _assocType = "NOMBRE";
        _assocValue = widget.hasAssocValue!;
        _assocName = widget.hasAssocName;
      }
    }
  }

  Future<void> _selectAssociationType() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Seleccionar asociación'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'PAGO'),
            child: const Text('Pago'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'NOMBRE'),
            child: const Text('Nombre'),
          ),
        ],
      ),
    );

    if (selected != null) {
      final selectedItem = await showDialog<dynamic>(
        context: NavigatorKeys.navKey.currentContext!,
        builder: (_) => ModalSelectionList(
          type: selected,
        ),
      );

      if (selectedItem != null) {
        debugPrint(selectedItem.toString());
        setState(() {
          _assocType = selected;
          _assocValue = selectedItem['id'];
          _assocName = selectedItem['name'];
        });
      } else {
        setState(() {
          _isAssociated = false;
        });
      }
    } else {
      setState(() {
        _isAssociated = false;
      });
    }
  }

  void editNote(String title, String content, String noteId,
      String? associatedType, String? associatedValue) async {
    await notesServices.editNote(
        id: noteId,
        title: title,
        content: content,
        associatedType: associatedType,
        associatedValue: associatedValue);
  }

  void addNote(String title, String content, String? associatedType,
      String? associatedValue) async {
    await notesServices.addNote(
        title: title,
        content: content,
        associatedType: associatedType,
        associatedValue: associatedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese título' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Nota'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese nota' : null,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isAssociated,
                    onChanged: (val) async {
                      if (val == true) {
                        await _selectAssociationType();
                        setState(() {
                          _isAssociated = _assocValue != null;
                        });
                      } else {
                        setState(() {
                          _isAssociated = false;
                          _assocType = null;
                          _assocValue = null;
                        });
                      }
                    },
                  ),
                  const Text('Asociado')
                ],
              ),
              if (_isAssociated && _assocType != null && _assocValue != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.link, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _assocType == 'PAGO'
                              ? 'Asociado a pago: $_assocName'
                              : 'Asociado a nombre: $_assocName',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.note?.id != null) {
                editNote(
                    _nameController.text,
                    _contentController.text,
                    widget.note!.id!,
                    _isAssociated ? _assocType : null,
                    _isAssociated ? _assocValue : null);
              } else {
                addNote(
                    _nameController.text,
                    _contentController.text,
                    _isAssociated ? _assocType : null,
                    _isAssociated ? _assocValue : null);
              }
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}
