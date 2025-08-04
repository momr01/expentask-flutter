import 'package:flutter/material.dart';
import 'dart:async';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/notes/services/notes_services.dart';
import 'package:payments_management/features/notes/widgets/filtro_screen.dart';
import 'package:payments_management/features/notes/widgets/modal_add_edit_note.dart';
import 'package:payments_management/features/notes/widgets/notes_main_grid.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/note/note.dart';
import 'package:payments_management/models/payment/payment.dart';

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  final bool isModal;
  const NotesScreen({super.key, required this.isModal});

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
      builder: (_) => ModalAddEditNote(
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
    return !widget.isModal
        ? Scaffold(
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
                        FiltroScreen(current: _filter, onSelect: _selectFilter),
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
              child: NotesMainGrid(
                // searchController: searchController,
                // searchQuery: searchQuery,
                // onSearchChanged: onSearchChanged,
                // isLoading: isLoading,
                // filteredNotes: filteredNotes,
                // onEditNote: onEditNote,
                // onDeleteNote: onDeleteNote
                searchController: _searchController,
                searchQuery: _searchQuery,
                onSearchChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                isLoading: _isLoading,
                filteredNotes: _filteredNotes,
                onEditNote: _addOrEditNote,
                onDeleteNote: _deleteNote,
              ),
              /* child: Column(
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
        ),*/
            ),
          )
        : AlertDialog(
            title: const Text("Notas"),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: NotesMainGrid(
                  isModal: true,
                  // searchController: searchController,
                  // searchQuery: searchQuery,
                  // onSearchChanged: onSearchChanged,
                  // isLoading: isLoading,
                  // filteredNotes: filteredNotes,
                  // onEditNote: onEditNote,
                  // onDeleteNote: onDeleteNote
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  onSearchChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  isLoading: _isLoading,
                  filteredNotes: _filteredNotes,
                  onEditNote: _addOrEditNote,
                  onDeleteNote: _deleteNote,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          );
  }
}
