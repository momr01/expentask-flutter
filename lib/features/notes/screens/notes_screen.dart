import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'dart:async';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/notes/services/notes_services.dart';
import 'package:payments_management/features/notes/widgets/filtro_screen.dart';
import 'package:payments_management/features/notes/widgets/modal_add_edit_note.dart';
import 'package:payments_management/features/notes/widgets/notes_main_grid.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/note/note.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  final bool isModal;
  final bool hasId;
  final PaymentWithSharedDuty? payment;
  final PaymentName? name;
  const NotesScreen(
      {super.key,
      required this.isModal,
      this.hasId = false,
      this.payment,
      this.name});

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
    final data = widget.hasId
        ? widget.payment != null
            ? await notesServices.fetchPaymentNotes(
                paymentId: widget.payment!.id!)
            : await notesServices.fetchNameNotes(nameId: widget.name!.id!)
        : await notesServices.fetchAllNotes();
    setState(() {
      _notes = data;
      _isLoading = false;
    });
  }

  void _addOrEditNote({Note? note}) async {
    debugPrint("opcion 2");
    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => ModalAddEditNote(
        note: note,
        hasAssocType: widget.hasId
            ? widget.payment != null
                ? "PAGO"
                : "NOMBRE"
            : null,
        hasAssocValue: widget.hasId
            ? widget.payment != null
                ? widget.payment!.id
                : widget.name!.id
            : null,
        hasAssocName: widget.hasId
            ? widget.payment != null
                ? widget.payment!.name.name
                : widget.name!.name
            : null,
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  void _deleteNote(Note note) async {
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
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

  Future<void> _refreshData() async {
    _loadNotes();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isModal
        ? TitleSearchLayout(
            refreshData: _refreshData,
            isLoading: _isLoading,
            title: "Notas",
            searchController: _searchController,
            onSearch: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            withFloatBtn: true,
            floatBtn: Column(
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
            child: Expanded(
                child: Component(
                    filteredNotes: _filteredNotes,
                    isLoading: _isLoading,
                    onDeleteNote: _deleteNote,
                    onEditNote: _addOrEditNote)),
          )
        : AlertDialog(
            title: const Center(child: Text("Notas")),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: NotesMainGrid(
                  isModal: true,
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
                onPressed: () => _addOrEditNote(),
                child: const Text('Nueva'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          );
  }
}
