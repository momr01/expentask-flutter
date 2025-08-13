import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/models/note/note.dart';

class NotesMainGrid extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final bool isLoading;
  final List<Note> filteredNotes;
  final void Function({Note? note}) onEditNote;
  final void Function(Note note) onDeleteNote;
  final bool isModal;
  const NotesMainGrid(
      {super.key,
      required this.searchController,
      required this.searchQuery,
      required this.onSearchChanged,
      required this.isLoading,
      required this.filteredNotes,
      required this.onEditNote,
      required this.onDeleteNote,
      this.isModal = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: isModal ? MainAxisSize.min : MainAxisSize.max,
      children: [
        !isModal
            ? Text('Notas', style: Theme.of(context).textTheme.headlineMedium)
            : const SizedBox(),
        SizedBox(height: isModal ? 12 : 10),
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            //hintText: placeholder,
            labelText: 'Buscar nota',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            filled: true,
            fillColor: GlobalVariables.greyBackgroundColor,
            isDense: true,
            errorStyle: TextStyle(color: Colors.red, fontSize: 14),
          ),
          onChanged: onSearchChanged,
          maxLines: 1,
        ),
        const SizedBox(height: 12),
        isModal
            ? SizedBox(
                height: 300,
                child: Component(
                    filteredNotes: filteredNotes,
                    isLoading: isLoading,
                    onDeleteNote: onDeleteNote,
                    onEditNote: onEditNote),
              )
            : Expanded(
                child: Component(
                    filteredNotes: filteredNotes,
                    isLoading: isLoading,
                    onDeleteNote: onDeleteNote,
                    onEditNote: onEditNote))
      ],
    );
  }
}

class Component extends StatelessWidget {
  final bool isLoading;
  final List<Note> filteredNotes;
  final void Function({Note? note}) onEditNote;
  final void Function(Note note) onDeleteNote;

  const Component({
    super.key,
    required this.filteredNotes,
    required this.isLoading,
    required this.onDeleteNote,
    required this.onEditNote,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredNotes.isEmpty
            ? const Center(child: Text('No existen notas'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredNotes.length,
                itemBuilder: (ctx, i) {
                  final note = filteredNotes[i];
                  return InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                              // _addOrEditNote(note: note);
                              onEditNote(note: note);
                            },
                            child: const Text('Editar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //  _deleteNote(note);
                              onDeleteNote(note);
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
                            Text(note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                    onPressed: () => onEditNote(note: note)),
                                IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => onDeleteNote(note)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
  }
}
