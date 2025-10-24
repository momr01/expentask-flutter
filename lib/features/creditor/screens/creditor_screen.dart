import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_layout.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/float_btn.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/creditor/services/creditor_services.dart';
import 'package:payments_management/features/shared_duty/screens/shared_duty_screen.dart';
import 'package:payments_management/models/creditor/creditor.dart';

class CreditorScreen extends StatefulWidget {
  static const String routeName = '/creditor';
  const CreditorScreen({super.key});

  @override
  State<CreditorScreen> createState() => _CreditorScreenState();
}

class _CreditorScreenState extends State<CreditorScreen> {
  //final repo = DataRepository.instance;
  List<Creditor>? creditors;
  // List<Payment> payments = []; // ya no nullable, siempre inicializada
  List<Creditor> _foundCreditors = [];
  final TextEditingController _searchController = TextEditingController();
  final CreditorServices creditorServices = CreditorServices();
  String filtro = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchActiveCreditors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchActiveCreditors() {
    fetchData<Creditor>(
      // context: context,
      fetchFunction: creditorServices.fetchActiveCreditors,
      onStart: () => setState(() => _isLoading = true),
      onSuccess: (items) => setState(() {
        creditors = items;
        _foundCreditors = items;
      }),
      onComplete: () => setState(() => _isLoading = false),
    );
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundCreditors = runFilter<Creditor>(
        keyword,
        creditors!,
        (creditor) =>
            creditor.name.toLowerCase().contains(keyword.toLowerCase()),
      );
    });
  }

  void navigateToCreditorsManagement() async {
    // fromGroupDetailsToManageGroup(context,
    //     Group(name: "", dataEntry: "", isActive: false, paymentNames: []))

    // ;

    // Abrir management de acreedores
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreditorScreen()),
    );
    setState(() {}); // en caso de cambios
  }

  Future<void> _refreshData() async {
    fetchActiveCreditors();
    _searchController.clear();
  }

  Future<void> _deleteCreditor(String id) async {
    await creditorServices.disableCreditor(creditorId: id);
  }

  @override
  Widget build(BuildContext context) {
    // final listaFiltrada = repo.acreedores
    //     .where((a) =>
    //         a.nombre.toLowerCase().contains(filtro.toLowerCase()) ||
    //         a.descripcion.toLowerCase().contains(filtro.toLowerCase()))
    //     .toList()
    //   ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    final listaFiltrada = _foundCreditors
        .where((a) =>
            a.name.toLowerCase().contains(filtro.toLowerCase()) ||
            a.description.toLowerCase().contains(filtro.toLowerCase()))
        .toList()
      ..sort((a, b) => b.dataEntry.compareTo(a.dataEntry));

    return TitleSearchLayout(
      refreshData: _refreshData,
      isLoading: _isLoading,
      title: 'Acreedores',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar acreedor...",
      withFloatBtn: true,
      //  floatBtnLocation: FloatingActionButtonLocation.,
      floatBtn: FloatBtn(
        loadFloatBtn: false,
        onTapFloatBtn: () async {
          final nuevo = await Navigator.push<Acreedor?>(
            context,
            MaterialPageRoute(builder: (_) => const AcreedorFormScreen()),
          );
          if (nuevo != null) {
            setState(() {
              // repo.addAcreedor(nuevo);
            });
          }
        },
      ),
      child: Expanded(
        child: listaFiltrada.isEmpty
            ? const Center(child: Text("No se encontraron acreedores"))
            : ListView.builder(
                itemCount: listaFiltrada.length,
                itemBuilder: (context, index) {
                  final a = listaFiltrada[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(a.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text(
                          //"${a.description}\nCreado: ${a.fechaCreacion.day.toString().padLeft(2, '0')}/${a.fechaCreacion.month.toString().padLeft(2, '0')}/${a.fechaCreacion.year}"),
                          "${a.description.trim() != "-" ? a.description : ""}\nCreado: ${parseJsDateString(a.dataEntry)}"),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () async {
                              final edited = await Navigator.push<Acreedor?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AcreedorFormScreen(acreedor: a),
                                ),
                              );
                              if (edited != null) {
                                setState(() {
                                  //   repo.updateAcreedor(edited);
                                  debugPrint("update");
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () => _confirmDelete(a),
                            // onPressed: () => {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(title: const Text("Acreedores")),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.indigo,
    //     child: const Icon(Icons.add),
    //     onPressed: () async {
    //       final nuevo = await Navigator.push<Acreedor?>(
    //         context,
    //         MaterialPageRoute(builder: (_) => const AcreedorFormScreen()),
    //       );
    //       if (nuevo != null) {
    //         setState(() {
    //           repo.addAcreedor(nuevo);
    //         });
    //       }
    //     },
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(12),
    //     child: Column(
    //       children: [
    //         TextField(
    //           controller: _searchController,
    //           decoration: InputDecoration(
    //             hintText: "Buscar acreedor...",
    //             prefixIcon: const Icon(Icons.search),
    //             suffixIcon: filtro.isNotEmpty
    //                 ? IconButton(
    //                     icon: const Icon(Icons.clear),
    //                     onPressed: () {
    //                       setState(() {
    //                         filtro = "";
    //                         _searchController.clear();
    //                       });
    //                     },
    //                   )
    //                 : null,
    //             filled: true,
    //             fillColor: Colors.white,
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide.none,
    //             ),
    //           ),
    //           onChanged: (v) => setState(() => filtro = v),
    //         ),
    //         const SizedBox(height: 12),
    //         Expanded(
    //           child: listaFiltrada.isEmpty
    //               ? const Center(child: Text("No se encontraron acreedores"))
    //               : ListView.builder(
    //                   itemCount: listaFiltrada.length,
    //                   itemBuilder: (context, index) {
    //                     final a = listaFiltrada[index];
    //                     return Card(
    //                       margin: const EdgeInsets.symmetric(vertical: 6),
    //                       shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(12)),
    //                       elevation: 3,
    //                       child: ListTile(
    //                         contentPadding: const EdgeInsets.all(12),
    //                         title: Text(a.nombre,
    //                             style: const TextStyle(
    //                                 fontWeight: FontWeight.bold, fontSize: 18)),
    //                         subtitle: Text(
    //                             "${a.descripcion}\nCreado: ${a.fechaCreacion.day.toString().padLeft(2, '0')}/${a.fechaCreacion.month.toString().padLeft(2, '0')}/${a.fechaCreacion.year}"),
    //                         isThreeLine: true,
    //                         trailing: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             IconButton(
    //                               icon: const Icon(Icons.edit,
    //                                   color: Colors.indigo),
    //                               onPressed: () async {
    //                                 final edited =
    //                                     await Navigator.push<Acreedor?>(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                     builder: (_) =>
    //                                         AcreedorFormScreen(acreedor: a),
    //                                   ),
    //                                 );
    //                                 if (edited != null) {
    //                                   setState(() {
    //                                     repo.updateAcreedor(edited);
    //                                   });
    //                                 }
    //                               },
    //                             ),
    //                             IconButton(
    //                               icon: const Icon(Icons.delete,
    //                                   color: Colors.redAccent),
    //                               onPressed: () => _confirmDelete(a),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  void _confirmDelete(Creditor a) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text("¿Desea eliminar el acreedor '${a.name}'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            // onPressed: () async {
            //   setState(() {
            //     //repo.removeAcreedor(a);
            //     creditorServices.disableCreditor(creditorId: a.id!);
            //   });
            //   Navigator.pop(ctx);
            // },
            onPressed: () => _deleteCreditor(a.id!),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    //}
  }
}

// ------------------- SCREEN: GESTION ACREEDORES -------------------
// class AcreedoresScreen extends StatefulWidget {
//   const AcreedoresScreen({super.key});

//   @override
//   State<AcreedoresScreen> createState() => _AcreedoresScreenState();
// }

//class _AcreedoresScreenState extends State<AcreedoresScreen> {
// //final repo = DataRepository.instance;
// List<Creditor>? creditors;
// // List<Payment> payments = []; // ya no nullable, siempre inicializada
// List<Creditor> _foundCreditors = [];
// final TextEditingController _searchController = TextEditingController();
// final CreditorServices creditorServices = CreditorServices();
// String filtro = "";

// bool _isLoading = false;

// @override
// void initState() {
//   super.initState();
//   fetchActiveCreditors();
// }

// @override
// void dispose() {
//   _searchController.dispose();
//   super.dispose();
// }

// void fetchActiveCreditors() {
//   fetchData<Creditor>(
//     // context: context,
//     fetchFunction: creditorServices.fetchActiveCreditors,
//     onStart: () => setState(() => _isLoading = true),
//     onSuccess: (items) => setState(() {
//       creditors = items;
//       _foundCreditors = items;
//     }),
//     onComplete: () => setState(() => _isLoading = false),
//   );
// }

// void _runFilter(String keyword) {
//   setState(() {
//     _foundCreditors = runFilter<Creditor>(
//       keyword,
//       creditors!,
//       (creditor) =>
//           creditor.name.toLowerCase().contains(keyword.toLowerCase()),
//     );
//   });
// }

// void navigateToCreditorsManagement() async {
//   // fromGroupDetailsToManageGroup(context,
//   //     Group(name: "", dataEntry: "", isActive: false, paymentNames: []))

//   // ;

//   // Abrir management de acreedores
//   await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (_) => const AcreedoresScreen()),
//   );
//   setState(() {}); // en caso de cambios
// }

// Future<void> _refreshData() async {
//   fetchActiveCreditors();
//   _searchController.clear();
// }

// Future<void> _deleteCreditor(String id) async {
//   await creditorServices.disableCreditor(creditorId: id);
// }

// @override
// Widget build(BuildContext context) {
//   // final listaFiltrada = repo.acreedores
//   //     .where((a) =>
//   //         a.nombre.toLowerCase().contains(filtro.toLowerCase()) ||
//   //         a.descripcion.toLowerCase().contains(filtro.toLowerCase()))
//   //     .toList()
//   //   ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
//   final listaFiltrada = _foundCreditors
//       .where((a) =>
//           a.name.toLowerCase().contains(filtro.toLowerCase()) ||
//           a.description.toLowerCase().contains(filtro.toLowerCase()))
//       .toList()
//     ..sort((a, b) => b.dataEntry.compareTo(a.dataEntry));

//   return TitleSearchLayout(
//     refreshData: _refreshData,
//     isLoading: _isLoading,
//     title: 'Acreedores',
//     searchController: _searchController,
//     onSearch: _runFilter,
//     searchPlaceholder: "Buscar acreedor...",
//     withFloatBtn: true,
//     //  floatBtnLocation: FloatingActionButtonLocation.,
//     floatBtn: FloatBtn(
//       loadFloatBtn: false,
//       onTapFloatBtn: () async {
//         final nuevo = await Navigator.push<Acreedor?>(
//           context,
//           MaterialPageRoute(builder: (_) => const AcreedorFormScreen()),
//         );
//         if (nuevo != null) {
//           setState(() {
//             // repo.addAcreedor(nuevo);
//           });
//         }
//       },
//     ),
//     child: Expanded(
//       child: listaFiltrada.isEmpty
//           ? const Center(child: Text("No se encontraron acreedores"))
//           : ListView.builder(
//               itemCount: listaFiltrada.length,
//               itemBuilder: (context, index) {
//                 final a = listaFiltrada[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),
//                     title: Text(a.name,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18)),
//                     subtitle: Text(
//                         //"${a.description}\nCreado: ${a.fechaCreacion.day.toString().padLeft(2, '0')}/${a.fechaCreacion.month.toString().padLeft(2, '0')}/${a.fechaCreacion.year}"),
//                         "${a.description.trim() != "-" ? a.description : ""}\nCreado: ${parseJsDateString(a.dataEntry)}"),
//                     isThreeLine: true,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.indigo),
//                           onPressed: () async {
//                             final edited = await Navigator.push<Acreedor?>(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     AcreedorFormScreen(acreedor: a),
//                               ),
//                             );
//                             if (edited != null) {
//                               setState(() {
//                                 //   repo.updateAcreedor(edited);
//                                 debugPrint("update");
//                               });
//                             }
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete,
//                               color: Colors.redAccent),
//                           onPressed: () => _confirmDelete(a),
//                           // onPressed: () => {},
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     ),
//   );

//   // return Scaffold(
//   //   appBar: AppBar(title: const Text("Acreedores")),
//   //   floatingActionButton: FloatingActionButton(
//   //     backgroundColor: Colors.indigo,
//   //     child: const Icon(Icons.add),
//   //     onPressed: () async {
//   //       final nuevo = await Navigator.push<Acreedor?>(
//   //         context,
//   //         MaterialPageRoute(builder: (_) => const AcreedorFormScreen()),
//   //       );
//   //       if (nuevo != null) {
//   //         setState(() {
//   //           repo.addAcreedor(nuevo);
//   //         });
//   //       }
//   //     },
//   //   ),
//   //   body: Padding(
//   //     padding: const EdgeInsets.all(12),
//   //     child: Column(
//   //       children: [
//   //         TextField(
//   //           controller: _searchController,
//   //           decoration: InputDecoration(
//   //             hintText: "Buscar acreedor...",
//   //             prefixIcon: const Icon(Icons.search),
//   //             suffixIcon: filtro.isNotEmpty
//   //                 ? IconButton(
//   //                     icon: const Icon(Icons.clear),
//   //                     onPressed: () {
//   //                       setState(() {
//   //                         filtro = "";
//   //                         _searchController.clear();
//   //                       });
//   //                     },
//   //                   )
//   //                 : null,
//   //             filled: true,
//   //             fillColor: Colors.white,
//   //             border: OutlineInputBorder(
//   //               borderRadius: BorderRadius.circular(12),
//   //               borderSide: BorderSide.none,
//   //             ),
//   //           ),
//   //           onChanged: (v) => setState(() => filtro = v),
//   //         ),
//   //         const SizedBox(height: 12),
//   //         Expanded(
//   //           child: listaFiltrada.isEmpty
//   //               ? const Center(child: Text("No se encontraron acreedores"))
//   //               : ListView.builder(
//   //                   itemCount: listaFiltrada.length,
//   //                   itemBuilder: (context, index) {
//   //                     final a = listaFiltrada[index];
//   //                     return Card(
//   //                       margin: const EdgeInsets.symmetric(vertical: 6),
//   //                       shape: RoundedRectangleBorder(
//   //                           borderRadius: BorderRadius.circular(12)),
//   //                       elevation: 3,
//   //                       child: ListTile(
//   //                         contentPadding: const EdgeInsets.all(12),
//   //                         title: Text(a.nombre,
//   //                             style: const TextStyle(
//   //                                 fontWeight: FontWeight.bold, fontSize: 18)),
//   //                         subtitle: Text(
//   //                             "${a.descripcion}\nCreado: ${a.fechaCreacion.day.toString().padLeft(2, '0')}/${a.fechaCreacion.month.toString().padLeft(2, '0')}/${a.fechaCreacion.year}"),
//   //                         isThreeLine: true,
//   //                         trailing: Row(
//   //                           mainAxisSize: MainAxisSize.min,
//   //                           children: [
//   //                             IconButton(
//   //                               icon: const Icon(Icons.edit,
//   //                                   color: Colors.indigo),
//   //                               onPressed: () async {
//   //                                 final edited =
//   //                                     await Navigator.push<Acreedor?>(
//   //                                   context,
//   //                                   MaterialPageRoute(
//   //                                     builder: (_) =>
//   //                                         AcreedorFormScreen(acreedor: a),
//   //                                   ),
//   //                                 );
//   //                                 if (edited != null) {
//   //                                   setState(() {
//   //                                     repo.updateAcreedor(edited);
//   //                                   });
//   //                                 }
//   //                               },
//   //                             ),
//   //                             IconButton(
//   //                               icon: const Icon(Icons.delete,
//   //                                   color: Colors.redAccent),
//   //                               onPressed: () => _confirmDelete(a),
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                     );
//   //                   },
//   //                 ),
//   //         ),
//   //       ],
//   //     ),
//   //   ),
//   // );
// }

// void _confirmDelete(Creditor a) {
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       title: const Text('Confirmar eliminación'),
//       content: Text("¿Desea eliminar el acreedor '${a.name}'?"),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancelar')),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//           // onPressed: () async {
//           //   setState(() {
//           //     //repo.removeAcreedor(a);
//           //     creditorServices.disableCreditor(creditorId: a.id!);
//           //   });
//           //   Navigator.pop(ctx);
//           // },
//           onPressed: () => _deleteCreditor(a.id!),
//           child: const Text('Eliminar'),
//         ),
//       ],
//     ),
//   );
// }
//}

// ------------------- SCREEN FORM ACREEDOR -------------------
class AcreedorFormScreen extends StatefulWidget {
//  final Acreedor? acreedor;
  final Creditor? acreedor;
  const AcreedorFormScreen({super.key, this.acreedor});

  @override
  State<AcreedorFormScreen> createState() => _AcreedorFormScreenState();
}

class _AcreedorFormScreenState extends State<AcreedorFormScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  // final TextEditingController _searchController = TextEditingController();
  // bool _isLoading = false;
  final CreditorServices creditorServices = CreditorServices();

  @override
  void initState() {
    super.initState();
    if (widget.acreedor != null) {
      // _nombreController.text = widget.acreedor!.nombre;
      // _descripcionController.text = widget.acreedor!.descripcion;
      _nombreController.text = widget.acreedor!.name;
      _descripcionController.text = widget.acreedor!.description;
    }
  }

  // void _runFilter(String value) {}

  // Future<void> _refreshData() async {
  //   // return true;
  // }

  void _confirmManage(final esEdicion) {
    debugPrint(esEdicion.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar ${esEdicion ? 'edición' : 'creación'}'),
        content:
            Text("¿Desea ${esEdicion ? 'editar' : 'agregar'} el acreedor?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: GlobalVariables.secondaryColor),
            // onPressed: () async {
            //   setState(() {
            //     //repo.removeAcreedor(a);
            //     creditorServices.disableCreditor(creditorId: a.id!);
            //   });
            //   Navigator.pop(ctx);
            // },
            onPressed: () => esEdicion ? _editCreditor() : _addCreditor(),
            child: Text(esEdicion ? 'Editar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editCreditor() async {
    await creditorServices.editCreditor(
        id: widget.acreedor!.id!,
        name: _nombreController.text,
        description: _descripcionController.text);
  }

  Future<void> _addCreditor() async {
    await creditorServices.addCreditor(
        name: _nombreController.text, description: _descripcionController.text);
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.acreedor != null;
    final nombreOk = _nombreController.text.isNotEmpty;

    return TitleLayout(
      title: esEdicion ? 'Editar Acreedor' : 'Nuevo Acreedor',
      /*  child: Padding(
          padding: const EdgeInsets.all(16),*/
      child: Column(
        children: [
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
                labelText: 'Nombre *', border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
                labelText: 'Descripción', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: nombreOk
                      ?
                      // esEdicion
                      //     ? _editCreditor
                      //     : _addCreditor
                      () => _confirmManage(esEdicion)

                      // () {
                      //     final now = DateTime.now();
                      //     // final nuevo = Acreedor(
                      //     //   id: widget.acreedor?.id ??
                      //     //       now.millisecondsSinceEpoch.toString(),
                      //     //   nombre: _nombreController.text,
                      //     //   descripcion: _descripcionController.text,
                      //     //   fechaCreacion:
                      //     //       widget.acreedor?.fechaCreacion ?? now,
                      //     // );
                      //     final nuevo = Creditor(
                      //         // id: widget.acreedor?.id ??
                      //         //     now.millisecondsSinceEpoch.toString(),
                      //         name: _nombreController.text,
                      //         description: _descripcionController.text,
                      //         dataEntry:
                      //             widget.acreedor?.dataEntry.toString() ??
                      //                 now.toString(),
                      //         isActive: true
                      //         // fechaCreacion:
                      //         //     widget.acreedor?.fechaCreacion ?? now,
                      //         );
                      //     Navigator.pop(context, nuevo);
                      //   }
                      : null,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: Text(
                    esEdicion ? 'Guardar cambios' : 'Agregar',
                    style:
                        TextStyle(color: nombreOk ? Colors.white : Colors.grey),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      // ),
    );

    /* return TitleSearchLayout(
      refreshData: _refreshData,
      isLoading: _isLoading,
      title: esEdicion ? 'Editar Acreedor' : 'Nuevo Acreedor',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar acreedor...",
      withFloatBtn: true,
      //  floatBtnLocation: FloatingActionButtonLocation.,
      floatBtn: FloatBtn(
        loadFloatBtn: false,
        onTapFloatBtn: () async {
          final nuevo = await Navigator.push<Acreedor?>(
            context,
            MaterialPageRoute(builder: (_) => const AcreedorFormScreen()),
          );
          if (nuevo != null) {
            setState(() {
              // repo.addAcreedor(nuevo);
            });
          }
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: 'Nombre *', border: OutlineInputBorder()),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: nombreOk
                        ? () {
                            final now = DateTime.now();
                            final nuevo = Acreedor(
                              id: widget.acreedor?.id ??
                                  now.millisecondsSinceEpoch.toString(),
                              nombre: _nombreController.text,
                              descripcion: _descripcionController.text,
                              fechaCreacion:
                                  widget.acreedor?.fechaCreacion ?? now,
                            );
                            Navigator.pop(context, nuevo);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: Text(esEdicion ? 'Guardar cambios' : 'Agregar'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );*/

    // return Scaffold(
    //   appBar:
    //       AppBar(title: Text(esEdicion ? 'Editar Acreedor' : 'Nuevo Acreedor')),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       children: [
    //         TextField(
    //           controller: _nombreController,
    //           decoration: const InputDecoration(
    //               labelText: 'Nombre *', border: OutlineInputBorder()),
    //           onChanged: (_) => setState(() {}),
    //         ),
    //         const SizedBox(height: 12),
    //         TextField(
    //           controller: _descripcionController,
    //           decoration: const InputDecoration(
    //               labelText: 'Descripción', border: OutlineInputBorder()),
    //           maxLines: 3,
    //         ),
    //         const SizedBox(height: 20),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: OutlinedButton(
    //                   onPressed: () => Navigator.pop(context),
    //                   child: const Text('Cancelar')),
    //             ),
    //             const SizedBox(width: 12),
    //             Expanded(
    //               child: ElevatedButton(
    //                 onPressed: nombreOk
    //                     ? () {
    //                         final now = DateTime.now();
    //                         final nuevo = Acreedor(
    //                           id: widget.acreedor?.id ??
    //                               now.millisecondsSinceEpoch.toString(),
    //                           nombre: _nombreController.text,
    //                           descripcion: _descripcionController.text,
    //                           fechaCreacion:
    //                               widget.acreedor?.fechaCreacion ?? now,
    //                         );
    //                         Navigator.pop(context, nuevo);
    //                       }
    //                     : null,
    //                 style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.indigo),
    //                 child: Text(esEdicion ? 'Guardar cambios' : 'Agregar'),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}


// ------------------- MODELO -------------------
// class Acreedor {
//   final String id;
//   String nombre;
//   String descripcion;
//   final DateTime fechaCreacion;

//   Acreedor({
//     required this.id,
//     required this.nombre,
//     required this.descripcion,
//     required this.fechaCreacion,
//   });
// }

// ------------------- SCREEN 1: LISTADO -------------------
// class AcreedoresScreen extends StatefulWidget {
//   const AcreedoresScreen({super.key});

//   @override
//   State<AcreedoresScreen> createState() => _AcreedoresScreenState();
// }

// class _AcreedoresScreenState extends State<AcreedoresScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Acreedor> acreedores = [
//     Acreedor(
//       id: "001",
//       nombre: "Juan Pérez",
//       descripcion: "Proveedor de materiales de construcción",
//       fechaCreacion: DateTime(2025, 9, 10),
//     ),
//     Acreedor(
//       id: "002",
//       nombre: "María López",
//       descripcion: "Servicios de mantenimiento",
//       fechaCreacion: DateTime(2025, 9, 15),
//     ),
//     Acreedor(
//       id: "003",
//       nombre: "Electricidad Mendoza",
//       descripcion: "Suministro eléctrico mensual",
//       fechaCreacion: DateTime(2025, 9, 20),
//     ),
//   ];

//   String filtro = "";

//   @override
//   Widget build(BuildContext context) {
//     final listaFiltrada = acreedores
//         .where((a) =>
//             a.nombre.toLowerCase().contains(filtro.toLowerCase()) ||
//             a.descripcion.toLowerCase().contains(filtro.toLowerCase()))
//         .toList();

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigo,
//         onPressed: () async {
//           final nuevo = await Navigator.push<Acreedor>(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AcreedorFormScreen(),
//             ),
//           );
//           if (nuevo != null) {
//             setState(() {
//               acreedores.add(nuevo);
//             });
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "ACREEDORES",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Buscar acreedor...",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: filtro.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           setState(() {
//                             filtro = "";
//                             _searchController.clear();
//                           });
//                         },
//                       )
//                     : null,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   filtro = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: listaFiltrada.isEmpty
//                   ? const Center(child: Text("No se encontraron acreedores"))
//                   : ListView.builder(
//                       itemCount: listaFiltrada.length,
//                       itemBuilder: (context, index) {
//                         final acreedor = listaFiltrada[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 3,
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(12),
//                             title: Text(
//                               acreedor.nombre,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                             subtitle: Text(
//                               "${acreedor.descripcion}\nCreado: ${acreedor.fechaCreacion.day.toString().padLeft(2, '0')}/${acreedor.fechaCreacion.month.toString().padLeft(2, '0')}/${acreedor.fechaCreacion.year}",
//                             ),
//                             isThreeLine: true,
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.edit,
//                                       color: Colors.indigo),
//                                   onPressed: () async {
//                                     final editado =
//                                         await Navigator.push<Acreedor>(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => AcreedorFormScreen(
//                                           acreedor: acreedor,
//                                         ),
//                                       ),
//                                     );
//                                     if (editado != null) {
//                                       setState(() {
//                                         acreedor.nombre = editado.nombre;
//                                         acreedor.descripcion =
//                                             editado.descripcion;
//                                       });
//                                     }
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete,
//                                       color: Colors.redAccent),
//                                   onPressed: () {
//                                     _confirmarEliminar(context, acreedor);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _confirmarEliminar(BuildContext context, Acreedor acreedor) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Confirmar eliminación"),
//         content: Text("¿Desea eliminar el acreedor '${acreedor.nombre}'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Cancelar"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             onPressed: () {
//               setState(() {
//                 acreedores.remove(acreedor);
//               });
//               Navigator.pop(ctx);
//             },
//             child: const Text("Eliminar"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ------------------- SCREEN 2: FORMULARIO -------------------
// class AcreedorFormScreen extends StatefulWidget {
//   final Acreedor? acreedor;
//   const AcreedorFormScreen({super.key, this.acreedor});

//   @override
//   State<AcreedorFormScreen> createState() => _AcreedorFormScreenState();
// }

// class _AcreedorFormScreenState extends State<AcreedorFormScreen> {
//   final TextEditingController _nombreController = TextEditingController();
//   final TextEditingController _descripcionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.acreedor != null) {
//       _nombreController.text = widget.acreedor!.nombre;
//       _descripcionController.text = widget.acreedor!.descripcion;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final esEdicion = widget.acreedor != null;
//     final nombreIngresado = _nombreController.text.isNotEmpty;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(esEdicion ? "Editar Acreedor" : "Nuevo Acreedor"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nombreController,
//               decoration: const InputDecoration(
//                 labelText: "Nombre *",
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _descripcionController,
//               decoration: const InputDecoration(
//                 labelText: "Descripción",
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Cancelar"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo),
//                     onPressed: nombreIngresado
//                         ? () {
//                             final nuevo = Acreedor(
//                               id: widget.acreedor?.id ??
//                                   DateTime.now()
//                                       .millisecondsSinceEpoch
//                                       .toString(),
//                               nombre: _nombreController.text,
//                               descripcion: _descripcionController.text,
//                               fechaCreacion: widget.acreedor?.fechaCreacion ??
//                                   DateTime.now(),
//                             );
//                             Navigator.pop(context, nuevo);
//                           }
//                         : null,
//                     child: Text(esEdicion ? "Guardar cambios" : "Agregar"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
