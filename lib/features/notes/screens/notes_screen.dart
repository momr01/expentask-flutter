//con textfield de busqueda

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'dart:async';

import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/notes/services/notes_services.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/note/note.dart';
import 'package:payments_management/models/payment/payment.dart';

/*class Note {
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
}*/

/*class Pago {
  final String id;
  final double monto;

  Pago({required this.id, required this.monto});
}

class Nombre {
  final String nombre;
  final String apellido;

  Nombre({required this.nombre, required this.apellido});
}*/

/*
import 'dart:async';
import 'package:flutter/material.dart';*/

/*
class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  //final NoteService _noteService = NoteService();
  final List<Note> _notes = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _filter = 'TODO';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
        _fetchNotes();
      }
    });
  }

  Future<void> _fetchNotes() async {
    setState(() => _isLoading = true);
   // final newNotes = await _noteService.getNotes(page: _currentPage);
     final newNotes = [];
    setState(() {
      _notes.addAll(newNotes);
      _isLoading = false;
      _hasMore = newNotes.isNotEmpty;
      if (_hasMore) _currentPage++;
    });
  }

  List<Note> get _filteredNotes {
    List<Note> filtered = _notes;
    if (_filter != 'TODO') {
      filtered = filtered.where((n) => n.associatedType == _filter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((n) =>
        n.name.toLowerCase().contains(query) ||
        n.content.toLowerCase().contains(query) ||
        (n.associatedValue?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return filtered;
  }

  void _openForm({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(note: note)),
    );
    if (result == true) {
      _notes.clear();
      _currentPage = 1;
      _hasMore = true;
      _fetchNotes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'TODO', child: Text('Todas')),
              const PopupMenuItem(value: 'PAGO', child: Text('Pagos')),
              const PopupMenuItem(value: 'NOMBRE', child: Text('Nombres')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.1,
                ),
                itemCount: _filteredNotes.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _filteredNotes.length) {
                    return const Center(
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 20.0,
                      ),
                    );
                  }
                  final note = _filteredNotes[index];
                  return GestureDetector(
                    onTap: () => _openForm(note: note),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.content,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            if (note.associatedValue != null)
                              Text(
                                '${note.associatedType}: ${note.associatedValue}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}*/

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Note> _notes = [];
  List<Payment> _payments = [];
  List<PaymentName> _names = [];
  String _filter = 'TODO';
  bool _isLoading = true;
  final NotesServices notesServices = NotesServices();
  final HistoricalServices historicalServices = HistoricalServices();
  final NamesServices namesServices = NamesServices();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadPayments();
    _loadNames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /* Future<void> _loadNotes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simular API
    setState(() {
      _notes.addAll([
        Note(id: '1', name: 'Nota A', content: 'Contenido A'),
        Note(
            id: '2',
            name: 'Nota B',
            content: 'Contenido B',
            associatedType: 'PAGO',
            associatedValue: 'Pago #1'),
      ]);
      _isLoading = false;
    });
  }*/

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    // final data = await obtenerRegistrosDesdeAPI();
    final data = await notesServices.fetchAllNotes();
    setState(() {
      _notes = data;
      //  _actualizarResumen();
      _isLoading = false;
    });
  }

  Future<void> _loadPayments() async {
    // setState(() => _isLoading = true);
    // final data = await obtenerRegistrosDesdeAPI();
    final data = await historicalServices.fetchAllPayments();
    setState(() {
      _payments = data;
      //  _actualizarResumen();
      // _isLoading = false;
    });
  }

  Future<void> _loadNames() async {
    // setState(() => _isLoading = true);
    // final data = await obtenerRegistrosDesdeAPI();
    final data = await namesServices.fetchPaymentNames();
    setState(() {
      _names = data;
      //  _actualizarResumen();
      // _isLoading = false;
    });
  }

  void _addOrEditNote({Note? note}) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (_) => NoteFormDialog(
        note: note,
        payments: _payments,
        names: _names,
      ),
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

  void _editNote({required Note note}) async {
    final result = await showDialog(
      context: context,
      builder: (_) => NoteFormDialog(
        note: note,
        payments: _payments,
        names: _names,
      ),
    );

    if (result == true) {
      // await _cargarRegistros();
      await _loadNotes();
    }
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
  }

  /* List<Note> get _filteredNotes {
    if (_filter == 'TODO') return _notes;
    return _notes.where((n) => n.associatedType == _filter).toList();
  }*/

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
                            return GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(note.title),
                                  content: Text(note.content),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cerrar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // _addOrEditNote(note: note);
                                        _editNote(note: note);
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
/*
 List<Note>? notes;
  List<Note> _foundNotes = [];
  final GroupsServices groupsServices = GroupsServices();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchActiveNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchActiveNotes() {
    fetchData<Note>(
      context: context,
      fetchFunction: groupsServices.fetchActiveGroups,
      onStart: () => setState(() => _isLoading = true),
      onSuccess: (items) => setState(() {
        notes = items;
        _foundNotes = items;
      }),
      onComplete: () => setState(() => _isLoading = false),
    );
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundNotes = runFilter<Note>(
        keyword,
        notes!,
        (note) => note.content.toLowerCase().contains(keyword.toLowerCase()),
      );
    });
  }
/*
  void navigateToAddNewGroup() {
    fromGroupDetailsToManageGroup(context,
        Group(name: "", dataEntry: "", isActive: false, paymentNames: []));
  }*/

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.orange.shade300,
          foregroundColor: GlobalVariables.primaryColor,
          onPressed: () {},
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                children: [
                  const MainTitle(title: 'Grupos'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      filled: true,
                      fillColor: GlobalVariables.greyBackgroundColor,
                      isDense: true,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                //children: _foundGroups
                children: groups
                    .map(
                      (group) => GestureDetector(
                        onTap: () => fromGroupsToGroupDetails(context, group),
                        child: GroupMainCard(
                          group: group,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
        isLoading: _isLoading,
        title: 'Notas',
        searchController: _searchController,
        onSearch: _runFilter,
        searchPlaceholder: "Buscar nota...",
      /*  withFloatBtn: true,
        floatBtnLocation: FloatingActionButtonLocation.centerDocked,
        onTapFloatBtn: navigateToAddNewGroup,*/


        /* child: ConditionalListView(
        items: groups,
        foundItems: _foundGroups,
        loader: const Loader(),
        emptyMessage: "¡No existen grupos para mostrar!",
        // itemBuilder: (context, payment) => PaymentCard(payment: payment),
        itemBuilder: (context, group) => GestureDetector(
          onTap: () => fromGroupsToGroupDetails(context, group),
          child: GroupMainCard(
            group: group,
          ),
        ),
        separatorBuilder: (context, _) => const Divider(),
      ),*/
        /* child: Expanded(
        child: GridView.count(
          primary: false,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          //children: _foundGroups
          children: _foundGroups
              .map(
                (group) => GestureDetector(
                  onTap: () => fromGroupsToGroupDetails(context, group),
                  child: GroupMainCard(
                    group: group,
                  ),
                ),
              )
              .toList(),
        ),
      ),*/
      /*  child: GroupGridView(
          groups: groups,
          foundGroups: _foundGroups,
          loader: const Loader(),
          emptyMessage: "¡No existen grupos para mostrar!",
        )*/
        child: ,
        
        );
  }
*/
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

/*
class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.name, style: Theme.of(context).textTheme.titleMedium),
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
}*/

class NoteFormDialog extends StatefulWidget {
  final Note? note;
  final List<PaymentName> names;
  final List<Payment> payments;
  const NoteFormDialog(
      {super.key, this.note, required this.names, required this.payments});

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
      final selectedItem = await showDialog<String>(
        context: context,
        builder: (_) => SelectDialog(
          type: selected,
          names: widget.names,
          payments: widget.payments,
        ),
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
                              //  ? 'Asociado a pago: $_assocValue'
                              ? 'Asociado a pago: ${widget.payments.where((payment) => payment.id == _assocValue).first.name.name} - ${widget.payments.where((payment) => payment.id == _assocValue).first.period}'
                              //: 'Asociado a nombre: $_assocValue',
                              : 'Asociado a nombre: ${widget.names.where((name) => name.id == _assocValue).first.name}',
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
                /*Note(
                  id: widget.note?.id ?? UniqueKey().toString(),
                  title: _nameController.text,
                  content: _contentController.text,
                  associatedType: _isAssociated ? _assocType : null,
                  associatedValue: _isAssociated ? _assocValue : null,
                ),*/
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
  final List<PaymentName> names;
  final List<Payment> payments;
  const SelectDialog(
      {super.key,
      required this.type,
      required this.names,
      required this.payments});

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  String _search = '';
  //late List<String> _items;
  late List<dynamic> _items;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'PAGO') {
      // _items = List.generate(20, (i) => 'Pago #${i + 1} - \$${(i + 1) * 10}');
      _items = widget.payments;
    } else {
      /// _items = List.generate(
      //  20, (i) => 'Nombre ${String.fromCharCode(65 + i)} Apellido');
      _items = widget.names;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final filtered = _items
        .where((item) => item.toLowerCase().contains(_search.toLowerCase()))
        .toList();*/
    final filtered = widget.type == 'PAGO'
        ? _items
            .where((item) =>
                item.name.name.toLowerCase().contains(_search.toLowerCase()))
            .toList()
        : _items
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
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(widget.type == "PAGO"
                      ? '${filtered[i].name.name} - ${filtered[i].period}'
                      : filtered[i].name),
                  onTap: () => Navigator.pop(context, filtered[i].id),
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
