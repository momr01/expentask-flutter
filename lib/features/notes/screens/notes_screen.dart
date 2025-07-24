import 'package:flutter/material.dart';

class Note {
  final String id;
  final String name;
  final String content;
  final String? associatedType; // 'PAGO' or 'NOMBRE'
  final String? associatedValue;

  Note({
    required this.id,
    required this.name,
    required this.content,
    this.associatedType,
    this.associatedValue,
  });
}

class Pago {
  final String id;
  final double monto;

  Pago({required this.id, required this.monto});
}

class Nombre {
  final String nombre;
  final String apellido;

  Nombre({required this.nombre, required this.apellido});
}

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  String _filter = 'TODO';

  void _addOrEditNote({Note? note}) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (_) => NoteFormDialog(note: note),
    );

    if (result != null) {
      setState(() {
        if (note != null) {
          final index = _notes.indexWhere((n) => n.id == note.id);
          _notes[index] = result;
        } else {
          _notes.add(result);
        }
      });
    }
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
  }

  List<Note> get _filteredNotes {
    if (_filter == 'TODO') return _notes;
    return _notes.where((n) => n.associatedType == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _filter = val),
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'TODO', child: Text('TODO')),
              PopupMenuItem(value: 'PAGO', child: Text('PAGOS')),
              PopupMenuItem(value: 'NOMBRE', child: Text('NOMBRES')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _filteredNotes.length,
        itemBuilder: (ctx, i) {
          final note = _filteredNotes[i];
          return GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(note.name),
                content: Text(note.content),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addOrEditNote(note: note);
                    },
                    child: const Text('Editar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteNote(note);
                    },
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        note.content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _addOrEditNote(note: note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _deleteNote(note),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoteFormDialog extends StatefulWidget {
  final Note? note;
  const NoteFormDialog({super.key, this.note});

  @override
  State<NoteFormDialog> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<NoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isAssociated = false;
  String? _assocType;
  String? _assocValue;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _nameController.text = widget.note!.name;
      _contentController.text = widget.note!.content;
      if (widget.note!.associatedType != null) {
        _isAssociated = true;
        _assocType = widget.note!.associatedType;
        _assocValue = widget.note!.associatedValue;
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
      final selectedItem = await showDialog<String>(
        context: context,
        builder: (_) => SelectDialog(type: selected),
      );

      if (selectedItem != null) {
        setState(() {
          _assocType = selected;
          _assocValue = selectedItem;
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese nombre' : null,
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
                              ? 'Asociado a pago: $_assocValue'
                              : 'Asociado a nombre: $_assocValue',
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                Note(
                  id: widget.note?.id ?? UniqueKey().toString(),
                  name: _nameController.text,
                  content: _contentController.text,
                  associatedType: _isAssociated ? _assocType : null,
                  associatedValue: _isAssociated ? _assocValue : null,
                ),
              );
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}

class SelectDialog extends StatefulWidget {
  final String type; // 'PAGO' o 'NOMBRE'
  const SelectDialog({super.key, required this.type});

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  String _search = '';
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'PAGO') {
      _items = List.generate(20, (i) => 'Pago #${i + 1} - \$${(i + 1) * 10}');
    } else {
      _items = List.generate(
          20, (i) => 'Nombre ${String.fromCharCode(65 + i)} Apellido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items
        .where((item) => item.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return AlertDialog(
      title: Text('Seleccionar ${widget.type}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Buscar...'),
            onChanged: (value) => setState(() => _search = value),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(filtered[i]),
                onTap: () => Navigator.pop(context, filtered[i]),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
