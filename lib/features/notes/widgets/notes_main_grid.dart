import 'package:flutter/material.dart';
import 'package:payments_management/models/note/note.dart';

class NotesMainGrid extends StatelessWidget {
  // final TextEditingController searchController;
  // final String searchQuery;
  final TextEditingController searchController;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final bool isLoading;
  final List<Note> filteredNotes;
  // final void Function(Note note) onEditNote;
  final void Function({Note? note}) onEditNote;
  final void Function(Note note) onDeleteNote;
  final bool isModal;
  const NotesMainGrid(
      {
      // super.key, required this.searchController, required this.searchQuery
      super.key,
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
            : SizedBox(),
        SizedBox(height: isModal ? 12 : 0),
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Buscar nota',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: onSearchChanged,
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
        /*  Expanded(
          // SizedBox(
          //  height:
          //      300,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredNotes.isEmpty
                  ? const Center(child: Text('No existen notas'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 20),
                                          onPressed: () =>
                                              // _addOrEditNote(note: note),
                                              onEditNote(note: note)),
                                      IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          onPressed: () => onDeleteNote(note)
                                          //_deleteNote(note),

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
        ),*/
      ],
    );
  }
}

class Component extends StatelessWidget {
  //final TextEditingController searchController;
  // final String searchQuery;
  //final Function(String) onSearchChanged;
  final bool isLoading;
  final List<Note> filteredNotes;
  // final void Function(Note note) onEditNote;
  final void Function({Note? note}) onEditNote;
  final void Function(Note note) onDeleteNote;
//  final bool isModal;

  const Component({
    super.key,
    // required this.searchController,
    // required this.searchQuery,
    required this.filteredNotes,
    required this.isLoading,
    //   required this.isModal,
    required this.onDeleteNote,
    required this.onEditNote,
    // required this.onSearchChanged
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
                                    onPressed: () =>
                                        // _addOrEditNote(note: note),
                                        onEditNote(note: note)),
                                IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => onDeleteNote(note)
                                    //_deleteNote(note),

                                    ),
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
