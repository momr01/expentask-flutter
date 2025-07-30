import 'package:flutter/material.dart';
import 'dart:async';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/notes/services/notes_services.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/note/note.dart';
import 'package:payments_management/models/payment/payment.dart';

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NotesServices notesServices = NotesServices();
  final HistoricalServices historicalServices = HistoricalServices();
  final NamesServices namesServices = NamesServices();

  String _searchQuery = '';
  List<Note> _notes = [];
  String _filter = 'TODO';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final data = await notesServices.fetchAllNotes();
    setState(() {
      _notes = data;
      _isLoading = false;
    });
  }

  void _addOrEditNote({Note? note}) async {
    debugPrint("opcion 2");
    final result = await showDialog(
      context: context,
      builder: (_) => NoteFormDialog(
        note: note,
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  void _deleteNote(Note note) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content:
            const Text("¿Estás seguro de que quieres eliminar este registro?"),
        actions: [
          TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(
              child: const Text("Eliminar"),
              onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await notesServices.disableNote(noteId: note.id!);
        await _loadNotes();
      } finally {}
    }
  }

  List<Note> get _filteredNotes {
    List<Note> filtered = _notes;
    if (_filter != 'TODO') {
      filtered = filtered.where((n) => n.associatedType == _filter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where((n) =>
              n.title.toLowerCase().contains(query) ||
              n.content.toLowerCase().contains(query) ||
              (n.associatedValue?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    return filtered;
  }

  void _selectFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const CustomDrawer(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'filter',
            child: const Icon(Icons.filter_alt),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) =>
                  _FilterSheet(current: _filter, onSelect: _selectFilter),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _addOrEditNote(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Notas', style: Theme.of(context).textTheme.headlineMedium),
            //const SizedBox(height: 12),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar nota',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredNotes.isEmpty
                      ? const Center(child: Text('No existen notas'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _filteredNotes.length,
                          itemBuilder: (ctx, i) {
                            final note = _filteredNotes[i];
                            return InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${note.associatedType == "PAGO" ? 'PAGO ASOCIADO' : note.associatedType == "NOMBRE" ? "NOMBRE ASOCIADO" : ""}= ${note.associatedType == "PAGO" ? '${note.payment!.name} / ${note.payment!.period}' : note.associatedType == "NOMBRE" ? note.name!.name : ""} ',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(note.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const SizedBox(height: 4),
                                      Expanded(
                                        child: Text(
                                          note.content,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                size: 20),
                                            onPressed: () =>
                                                _addOrEditNote(note: note),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                size: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final String current;
  final void Function(String) onSelect;

  const _FilterSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('TODO'),
          selected: current == 'TODO',
          onTap: () {
            onSelect('TODO');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.payments),
          title: const Text('PAGOS'),
          selected: current == 'PAGO',
          onTap: () {
            onSelect('PAGO');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('NOMBRES'),
          selected: current == 'NOMBRE',
          onTap: () {
            onSelect('NOMBRE');
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class NoteFormDialog extends StatefulWidget {
  final Note? note;
  const NoteFormDialog({
    super.key,
    this.note,
  });

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
        builder: (_) => SelectDialog(
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

class SelectDialog extends StatefulWidget {
  final String type; // 'PAGO' o 'NOMBRE'
  const SelectDialog({
    super.key,
    required this.type,
  });

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  final HistoricalServices historicalServices = HistoricalServices();
  final NamesServices namesServices = NamesServices();
  String _search = '';
  List<Payment> _payments = [];
  List<PaymentName> _names = [];
  bool _paymentsLoading = true;
  bool _namesLoading = true;

  Future<void> _loadPayments() async {
    setState(() => _paymentsLoading = true);
    final data = await historicalServices.fetchAllPayments();
    setState(() {
      _payments = data;
      _paymentsLoading = false;
    });
  }

  Future<void> _loadNames() async {
    setState(() => _namesLoading = true);
    final data = await namesServices.fetchPaymentNames();
    setState(() {
      _names = data;
      _namesLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPayments();
    _loadNames();
  }

  @override
  Widget build(BuildContext context) {
    final isPago = widget.type == 'PAGO';

    // final isLoading = isPago ? _paymentsLoading : _namesLoading;
    List<dynamic> items = isPago ? _payments : _names;

    final filtered = isPago
        ? items
            .where((item) =>
                item.name.name.toLowerCase().contains(_search.toLowerCase()))
            .toList()
        : items
            .where((item) =>
                item.name.toLowerCase().contains(_search.toLowerCase()))
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
          Flexible(
            child: SizedBox(
              //  Expanded(
              width: double.maxFinite,
              height: 300,
              child: _paymentsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => ListTile(
                        title: Text(widget.type == "PAGO"
                            ? '${filtered[i].name.name} - ${filtered[i].period}'
                            : filtered[i].name),
                        onTap: () => Navigator.pop(context, {
                          'id': filtered[i].id,
                          'name': widget.type == "PAGO"
                              ? '${filtered[i].name.name} - ${filtered[i].period}'
                              : filtered[i].name,
                        }),
                      ),
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
