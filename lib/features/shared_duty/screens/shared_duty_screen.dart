// --------------------------- APP ---------------------------
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/layouts/title_layout.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/float_btn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/creditor/screens/creditor_screen.dart';
import 'package:payments_management/features/creditor/services/creditor_services.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/shared_duty/services/shared_duty_services.dart';
import 'package:payments_management/models/creditor/creditor.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';
import 'package:payments_management/models/shared_duty/shared_duty.dart';

class SharedDutyScreen extends StatelessWidget {
  static const String routeName = '/shared-duty';
  const SharedDutyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Obligaciones Compartidas',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: Colors.indigo,
    //     scaffoldBackgroundColor: Colors.grey[50],
    //     textTheme: const TextTheme(
    //       bodyMedium: TextStyle(color: Colors.black87),
    //     ),
    //   ),
    //   home: const SeleccionUsuarioScreen(),
    // );
    return
        // Scaffold(
        //   body: Column(
        //     children: [
        //       Text('Obligaciones Compartidas'),
        SeleccionUsuarioScreen();
    //     ],
    //   ),
    // );
  }
}

// --------------------------- MODELOS / REPOSITORIO EN MEMORIA ---------------------------
class Acreedor {
  final String id;
  String nombre;
  String descripcion;
  final DateTime fechaCreacion;

  Acreedor({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaCreacion,
  });
}

class Obligacion {
  final String id;
  final String
      nombre; // por simplicidad usamos nombre como "Pago X" o descripcion corta
  final String periodo;
  final String fechaPago;
  final String acreedorId;
  final String pagoId;
  bool finalizada;

  Obligacion({
    required this.id,
    required this.nombre,
    required this.periodo,
    required this.fechaPago,
    required this.acreedorId,
    required this.pagoId,
    this.finalizada = false,
  });
}

class Pago {
  final String id;
  final String nombre;
  final double monto;
  final DateTime fecha;

  Pago({
    required this.id,
    required this.nombre,
    required this.monto,
    required this.fecha,
  });
}

/// Repositorio sencillo en memoria para compartir datos entre pantallas
class DataRepository {
  DataRepository._privateConstructor();
  static final DataRepository instance = DataRepository._privateConstructor();

  final List<Acreedor> acreedores = [
    Acreedor(
      id: 'A001',
      nombre: 'Juan Pérez',
      descripcion: 'Proveedor de materiales',
      fechaCreacion: DateTime(2025, 9, 10),
    ),
    Acreedor(
      id: 'A002',
      nombre: 'María López',
      descripcion: 'Servicios de mantenimiento',
      fechaCreacion: DateTime(2025, 9, 15),
    ),
  ];

  // Obligaciones por usuario (key = nombreUsuario)
  final Map<String, List<Obligacion>> obligacionesPorUsuario = {
    'Usuario 1': [
      Obligacion(
        id: 'O001',
        nombre: 'Pago Luz',
        periodo: 'Ago 2025',
        fechaPago: '05/09/2025',
        acreedorId: 'A001',
        pagoId: 'P001',
        finalizada: false,
      ),
    ],
    'Usuario 2': [],
    'Usuario 3': [],
  };

  final List<Pago> pagos = List.generate(
    8,
    (i) => Pago(
      id: 'P00${i + 1}',
      nombre: 'Pago #${i + 1}',
      monto: (50 + i * 25).toDouble(),
      fecha: DateTime(2025, 9, 1 + i),
    ),
  );

  // util
  Acreedor? getAcreedorById(String id) =>
      acreedores.firstWhere((a) => a.id == id,
          orElse: () => Acreedor(
              id: 'NA',
              nombre: 'Sin Acreedor',
              descripcion: '',
              fechaCreacion: DateTime.now()));

  void addAcreedor(Acreedor a) => acreedores.add(a);
  void updateAcreedor(Acreedor a) {
    final i = acreedores.indexWhere((x) => x.id == a.id);
    if (i >= 0) acreedores[i] = a;
  }

  void removeAcreedor(Acreedor a) {
    acreedores.removeWhere((x) => x.id == a.id);
    // opcional: limpiar obligaciones asociadas (no lo hacemos para no borrar datos automáticamente)
  }

  List<Obligacion> obligacionesForUsuario(String usuario) =>
      obligacionesPorUsuario.putIfAbsent(usuario, () => []);

  void addObligacion(String usuario, Obligacion o) {
    final list = obligacionesForUsuario(usuario);
    list.add(o);
  }
}

// ------------------- SCREEN 1: SELECCION USUARIO -------------------
class SeleccionUsuarioScreen extends StatefulWidget {
  const SeleccionUsuarioScreen({super.key});

  @override
  State<SeleccionUsuarioScreen> createState() => _SeleccionUsuarioScreenState();
}

class _SeleccionUsuarioScreenState extends State<SeleccionUsuarioScreen> {
/*  final TextEditingController _searchController = TextEditingController();
  final List<String> usuarios = ["Usuario 1", "Usuario 2", "Usuario 3"];
  String filtro = "";*/

  List<Creditor>? creditors;
  List<Creditor> _foundCreditors = [];
  final CreditorServices creditorServices = CreditorServices();
  final TextEditingController _searchController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    // final listaFiltrada = usuarios
    //     .where((u) => u.toLowerCase().contains(filtro.toLowerCase()))
    //     .toList();

    return TitleSearchLayout(
      refreshData: _refreshData,
      isLoading: _isLoading,
      title: 'Obligaciones Compartidas',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar usuario...",
      withFloatBtn: true,
      //  floatBtnLocation: FloatingActionButtonLocation.,
      floatBtn: FloatBtn(
        loadFloatBtn: false,
        onTapFloatBtn: navigateToCreditorsManagement,
      ),
      child: Expanded(
        child: _foundCreditors.isEmpty
            ? const Center(child: Text("No se encontraron usuarios"))
            : ListView.builder(
                itemCount: _foundCreditors.length,
                itemBuilder: (context, index) {
                  final creditor = _foundCreditors[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 70),
                        backgroundColor: GlobalVariables.secondaryColor,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(creditor.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ObligacionesScreen(usuario: creditor.id!),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  );
                },
              ),
      ),
    );

    /* return Scaffold(
      appBar: AppBar(title: const Text("Obligaciones Compartidas")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.manage_accounts),
        tooltip: "Gestionar Acreedores",
        onPressed: () async {
          // Abrir management de acreedores
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AcreedoresScreen()),
          );
          setState(() {}); // en caso de cambios
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔹 Buscador con clear
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar usuario...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filtro.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            filtro = "";
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  filtro = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: listaFiltrada.isEmpty
                  ? const Center(child: Text("No se encontraron usuarios"))
                  : ListView.builder(
                      itemCount: listaFiltrada.length,
                      itemBuilder: (context, index) {
                        final usuario = listaFiltrada[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 70),
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(usuario,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ObligacionesScreen(usuario: usuario),
                                ),
                              ).then((_) => setState(() {}));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );*/
  }
}

// ------------------- SCREEN 2: OBLIGACIONES -------------------
class ObligacionesScreen extends StatefulWidget {
  final String usuario;
  const ObligacionesScreen({super.key, required this.usuario});

  @override
  State<ObligacionesScreen> createState() => _ObligacionesScreenState();
}

class _ObligacionesScreenState extends State<ObligacionesScreen> {
  final repo = DataRepository.instance;
  final TextEditingController _searchController = TextEditingController();
  bool mostrarAnulados = false;
  bool mostrarPendientes = true;
  bool mostrarFinalizados = false;
  String filtro = "";

  List<Creditor> creditors = [];
  List<SharedDuty>? sharedDuties;
//  List<Creditor> _foundCreditors = [];
  final CreditorServices creditorServices = CreditorServices();
  final SharedDutyServices sharedDutyServices = SharedDutyServices();
  bool _isLoadingCreditors = false;
  bool _isLoadingSharedDuties = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchActiveCreditors();
    fetchSharedDutiesByCreditor();
  }

  void fetchActiveCreditors() {
    debugPrint(widget.usuario);
    fetchData<Creditor>(
      // context: context,
      fetchFunction: creditorServices.fetchActiveCreditors,
      onStart: () => setState(() => _isLoadingCreditors = true),
      onSuccess: (items) => setState(() {
        creditors = items;
        // _foundCreditors = items;
      }),
      onComplete: () => setState(() => _isLoadingCreditors = false),
    );
  }

  void fetchSharedDutiesByCreditor() {
    fetchData<SharedDuty>(
      // context: context,
      fetchFunction: () =>
          sharedDutyServices.fetchSharedDutiesByCreditor(widget.usuario),
      onStart: () => setState(() => _isLoadingSharedDuties = true),
      onSuccess: (items) => setState(() {
        sharedDuties = items;
        //  _foundCreditors = items;
      }),
      onComplete: () => setState(() => _isLoadingSharedDuties = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  final obligacionesAll = repo.obligacionesForUsuario(widget.usuario);
    final obligacionesAll = sharedDuties;
    final listaFiltrada = obligacionesAll != null
        ? obligacionesAll.where((o) {
            // final matchesStatus = o.finalizada != mostrarPendientes;
            // final matchesStatus = o.isCompleted != mostrarPendientes;
            final matchesStatus = (mostrarAnulados && !o.isActive) ||
                (mostrarPendientes && o.isActive && !o.isCompleted) ||
                (mostrarFinalizados && o.isActive && o.isCompleted);
            final q = filtro.toLowerCase();
            // final matchesQuery = o.nombre.toLowerCase().contains(q) ||
            //     o.id.toLowerCase().contains(q) ||
            //     o.periodo.toLowerCase().contains(q) ||
            //     o.fechaPago.toLowerCase().contains(q);
            final matchesQuery =
                o.payment.name.name.toLowerCase().contains(q) ||
                    o.id!.toLowerCase().contains(q) ||
                    o.payment.period.toLowerCase().contains(q) ||
                    o.payment.deadline.toString().toLowerCase().contains(q);
            return matchesStatus && matchesQuery;
          }).toList()
        : [];

    return Scaffold(
      // appBar: AppBar(title: Text("Obligaciones de ${widget.usuario}")),
      appBar: customAppBar(context),
      // drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
        tooltip: 'Agregar Obligación',
        onPressed: () async {
          debugPrint(
              "boton + desde obligaciones pendientes finalizadas anuladas");
          // Primero elegir el acreedor con un diálogo (si no hay acreedores, avisar)
          //  if (repo.acreedores.isEmpty) {
          if (creditors.isEmpty) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Sin acreedores'),
                content: const Text(
                    'No hay acreedores cargados. Agregá uno desde Gestión de Acreedores.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK'))
                ],
              ),
            );
            return;
          }

          final selectedAcreedor =
              //  await _pickAcreedorDialog(context, repo.acreedores);
              await _pickAcreedorDialog(context, creditors);
          if (selectedAcreedor == null) return;

          final nuevo = await Navigator.push<Obligacion?>(
            context,
            MaterialPageRoute(
              builder: (_) => NuevaObligacionScreen(
                usuario: widget.usuario,
                acreedor: selectedAcreedor,
              ),
            ),
          );

          if (nuevo != null) {
            setState(() {
              repo.addObligacion(widget.usuario, nuevo);
            });
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text("Pendientes"),
                  labelStyle: TextStyle(
                      color: mostrarPendientes ? Colors.white : Colors.black),
                  selected: mostrarPendientes,
                  selectedColor: Colors.indigo,
                  backgroundColor: Colors.grey[300],
                  onSelected: (_) => setState(() {
                    mostrarPendientes = true;
                    mostrarAnulados = false;
                    mostrarFinalizados = false;
                  }),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text("Finalizadas"),
                  labelStyle: TextStyle(
                      color: mostrarFinalizados ? Colors.white : Colors.black),
                  selected: mostrarFinalizados,
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[300],
                  onSelected: (_) => setState(() {
                    mostrarPendientes = false;
                    mostrarAnulados = false;
                    mostrarFinalizados = true;
                  }),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text("Anuladas"),
                  labelStyle: TextStyle(
                      color: mostrarAnulados ? Colors.white : Colors.black),
                  selected: mostrarAnulados,
                  selectedColor: Colors.red,
                  backgroundColor: Colors.grey[300],
                  onSelected: (_) => setState(() {
                    mostrarAnulados = true;
                    mostrarPendientes = false;
                    mostrarFinalizados = false;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: mostrarPendientes
                    ? Colors.indigo[100]
                    : mostrarAnulados
                        ? Colors.red[100]
                        : Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Total ${mostrarPendientes ? "Pendientes" : mostrarAnulados ? "Anuladas" : "Finalizadas"}: ${listaFiltrada.length}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar obligación...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filtro.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            filtro = "";
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (value) => setState(() => filtro = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100]),
                child: listaFiltrada.isEmpty
                    ? const Center(
                        child: Text("No se encontraron obligaciones"))
                    : ListView.builder(
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final o = listaFiltrada[index];
                          //final acreedor = repo.getAcreedorById(o.acreedorId);
                          // final acreedor = o.creditor.id;
                          final acreedor = o.creditor;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              //    color: o.finalizada
                              color: o.isActive
                                  ? o.isCompleted
                                      ? Colors.green[50]
                                      : Colors.white
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3))
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                  //o.nombre,
                                  o.payment.name.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  // "ID: ${o.id}\nPeriodo: ${o.periodo}\nFecha Pago: ${o.fechaPago}\nAcreedor: ${acreedor?.nombre ?? '—'}"),
                                  "ID: ${o.id}\nPeriodo: ${o.payment.period}\nFecha Vto: ${datetimeToStringWithDash(o.payment.deadline)}\nAcreedor: ${acreedor?.name ?? '—'}"),
                              isThreeLine: true,
                              trailing: Icon(
                                  // o.finalizada
                                  o.isActive
                                      ? o.isCompleted
                                          ? Icons.check_circle
                                          : Icons.pending_actions
                                      : Icons.close,
                                  //  color: o.finalizada
                                  color: o.isActive
                                      ? o.isCompleted
                                          ? Colors.green
                                          : Colors.orange
                                      : Colors.red),
                              onTap: mostrarPendientes
                                  ? () async {
                                      // final result =
                                      //   await
                                      _confirmarEdicion(context, o);

                                      // if (result == "finalizar") {
                                      //   debugPrint(
                                      //       "✅ Obligación finalizada con éxito");
                                      //   // refrescás lista, cerrás modal, o actualizás UI:
                                      //   setState(() {
                                      //     //  _loadData(); // ejemplo
                                      //     fetchSharedDutiesByCreditor();
                                      //   });
                                      // } else if (result == "cancelar") {
                                      //   debugPrint("❌ Se anuló la obligación");
                                      // } else {
                                      //   debugPrint("⚪ Acción cancelada");
                                      // }
                                    }
                                  : null,
                              // }
                              // : null,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Creditor?> _pickAcreedorDialog(
      // BuildContext context, List<Acreedor> lista) {
      BuildContext context,
      List<Creditor> lista) {
    return showDialog<Creditor>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Elegir acreedor'),
          content: SizedBox(
            width: double.maxFinite,
            child: _isLoadingCreditors
                ? Loader()
                : creditors.isEmpty
                    // : [].isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sin datos.",
                              style: TextStyle(
                                  color: GlobalVariables.primaryColor,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        //  itemCount: lista.length,
                        itemCount: creditors.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, i) {
                          //   final a = lista[i];
                          final a = creditors[i];
                          return ListTile(
                            // title: Text(a.nombre),
                            // subtitle: Text(a.descripcion),
                            title: Text(a.name),
                            subtitle: Text(a.description.contains("-")
                                ? ""
                                : a.description),
                            onTap: () => Navigator.pop(ctx, a),
                          );
                        },
                      ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'))
          ],
        );
      },
    );
  }

  Future<void> _disableSharedDuty(String sharedDutyId, String usuario) async {
    // await sharedDutyServices.addSharedDuty(
    //     creditor: widget.acreedor.id!,
    //     payment: pagoSeleccionado!.id!,
    //     description: _descripcionController.text != ""
    //         ? _descripcionController.text
    //         : "-");
    await sharedDutyServices.disableSharedDuty(
        sharedDutyId: sharedDutyId, usuario: usuario);
  }

  Future<void> _finishSharedDuty(String sharedDutyId, String usuario) async {
    // await sharedDutyServices.addSharedDuty(
    //     creditor: widget.acreedor.id!,
    //     payment: pagoSeleccionado!.id!,
    //     description: _descripcionController.text != ""
    //         ? _descripcionController.text
    //         : "-");
    await sharedDutyServices.finishSharedDuty(
        sharedDutyId: sharedDutyId, usuario: usuario);
  }

//  void _confirmarFinalizar(BuildContext context, Obligacion obligacion) {
  void _confirmarEdicion(BuildContext context, SharedDuty obligacion) async {
    // String result = "";
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            const Text("Editar"),
            GestureDetector(
                onTap: () {
                  debugPrint("editar");
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditarObligacionScreen(
                                obligacion: obligacion,
                              )));
                  EditarObligacionScreen(
                    obligacion: obligacion,
                  );
                },
                child: Icon(Icons.edit))
          ],
        ),
        content: Text(
          "¿Desea editar la obligación compartida <<${obligacion.payment.name.name}>>?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        actions: [
          // TextButton(
          //     onPressed: () => Navigator.pop(ctx), child: const Text("Anular")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            /* onPressed: () {
              setState(() {
                //  obligacion.finalizada = true;
              });
              Navigator.pop(ctx, "anular");
            },*/
            onPressed: () => _disableSharedDuty(obligacion.id!, widget.usuario),
            child: const Text(
              "Anular",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () =>
                //async {
                // setState(() {
                //  obligacion.finalizada = true;
                //  await
                _finishSharedDuty(obligacion.id!, widget.usuario),
            //});

            //   result = "finish";
            //  Navigator.pop(ctx, "finalizar");
            // },
            child: const Text(
              "Finalizar",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx, "cancelar"),
              child: const Text("Cancelar")),
        ],
      ),
    );

    // return result;
  }
}

// ------------------- SCREEN: NUEVA OBLIGACION (FORM) -------------------
class NuevaObligacionScreen extends StatefulWidget {
  final String usuario;
  //final Acreedor acreedor; // bloqueado en el formulario
  final Creditor acreedor;

  const NuevaObligacionScreen(
      {super.key, required this.usuario, required this.acreedor});

  @override
  State<NuevaObligacionScreen> createState() => _NuevaObligacionScreenState();
}

class _NuevaObligacionScreenState extends State<NuevaObligacionScreen> {
  final repo = DataRepository.instance;
  final TextEditingController _descripcionController = TextEditingController();
  final HomeServices homeServices = HomeServices();
  final SharedDutyServices sharedDutyServices = SharedDutyServices();
  // Pago? pagoSeleccionado;
  PaymentWithSharedDuty? pagoSeleccionado;
  bool _isLoading = false;

  //List<Payment> payments = [];
  List<PaymentWithSharedDuty> payments = [];

  // Future<void> fetchUndonePayments() async {
  //   fetchData<Payment>(
  //     // context: null,
  //     fetchFunction: homeServices.fetchUndonePayments,
  //     onStart: () => setState(() => _isLoading = true),
  //     // onStart: () {
  //     //   _isLoading = true;
  //     //   notifyListeners();
  //     // },
  //     onSuccess: (items) => setState(() {
  //       payments = items;
  //       // _foundPayments = items;
  //     }),
  //     // onSuccess: (items) {
  //     //   payments = items;
  //     //   _foundPayments = items;
  //     //   notifyListeners();
  //     // },
  //     onComplete: () => setState(() => _isLoading = false),
  //     // onComplete: () {
  //     //   _isLoading = false;
  //     //   notifyListeners();
  //     // },
  //   );
  // }

  Future<List<PaymentWithSharedDuty>> fetchUndonePayments() async {
    final result = await homeServices.fetchUndonePaymentsWithSD();
    // setState(() {
    //   payments =
    //       result.where((element) => !element.sharedDuty.hasSharedDuty).toList();
    // });
    // return result;
    final filtered = result
        .where(
          (e) => !(e.sharedDuty.hasSharedDuty == true),
        )
        .toList();

    setState(() {
      payments = filtered;
    });

    return filtered;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  fetchUndonePayments();
  }

  void _confirmAdd() {
    // debugPrint(esEdicion.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar creación'),
        content: Text("¿Desea agregar la obligación compartida?"),
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
            onPressed: () => _addSharedDuty(),
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _addSharedDuty() async {
    await sharedDutyServices.addSharedDuty(
        creditor: widget.acreedor.id!,
        payment: pagoSeleccionado!.id!,
        description: _descripcionController.text != ""
            ? _descripcionController.text
            : "-");
  }

  @override
  Widget build(BuildContext context) {
    final nombreIngresado =
        _descripcionController.text.isNotEmpty; // optional; we won't require it
    final puedeAgregar =
        // pagoSeleccionado != null && widget.acreedor.id.isNotEmpty;
        pagoSeleccionado != null && widget.acreedor.id!.isNotEmpty;

    return TitleLayout(
      title: 'Nueva Obligación',
      child:
          //Padding(
          //  padding: const EdgeInsets.all(16),
          //child:
          Column(
        children: [
          // Acreedor bloqueado (solo muestra el seleccionado)
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Acreedor',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    // child: Text(widget.acreedor.nombre,
                    child: Text(widget.acreedor.name,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                const Icon(Icons.lock),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Pago (abre modal con listado)
          GestureDetector(
            onTap: () async {
              //  await fetchUndonePayments();
              final pago = await _openPagoSelector(context);
              if (pago != null) {
                setState(() {
                  pagoSeleccionado = pago;
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pago (seleccionar)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pagoSeleccionado != null
                          ? "${pagoSeleccionado!.name.name} — \$${pagoSeleccionado!.amount.toStringAsFixed(2)}"
                          : 'Tocar para seleccionar un pago',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Descripción opcional
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder()),
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'))),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: puedeAgregar
                      ? _confirmAdd
                      // () {
                      //     // crear nueva obligación y regresar
                      //     final now = DateTime.now();
                      //     final nuevo = Obligacion(
                      //       id: 'O${now.millisecondsSinceEpoch}',
                      //       nombre: pagoSeleccionado?.name.name ?? 'Obligación',
                      //       periodo:
                      //           '${now.month.toString().padLeft(2, '0')}/${now.year}',
                      //       fechaPago:
                      //           '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                      //       acreedorId: widget.acreedor.id!,
                      //       pagoId: pagoSeleccionado!.id!,
                      //       finalizada: false,
                      //     );
                      //     // Podríamos usar la descripcion en 'nombre' o en otro campo; para simplicidad lo ponemos en nombre si existe
                      //     if (_descripcionController.text.isNotEmpty) {
                      //       // no cambiar id pero ajustar nombre a descripción corta
                      //     }
                      //     Navigator.pop(context, nuevo);
                      //   }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalVariables.secondaryColor),
                  child: const Text('Agregar Obligación'),
                ),
              ),
            ],
          )
        ],
      ),
      //),
    );

/*
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Obligación')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Acreedor bloqueado (solo muestra el seleccionado)
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Acreedor',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      // child: Text(widget.acreedor.nombre,
                      child: Text(widget.acreedor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  const Icon(Icons.lock),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Pago (abre modal con listado)
            GestureDetector(
              onTap: () async {
                //  await fetchUndonePayments();
                final pago = await _openPagoSelector(context);
                if (pago != null) {
                  setState(() {
                    pagoSeleccionado = pago;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Pago (seleccionar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pagoSeleccionado != null
                            ? "${pagoSeleccionado!.name.name} — \$${pagoSeleccionado!.amount.toStringAsFixed(2)}"
                            : 'Tocar para seleccionar un pago',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Descripción opcional
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder()),
              maxLines: 3,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'))),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: puedeAgregar
                        ? () {
                            // crear nueva obligación y regresar
                            final now = DateTime.now();
                            final nuevo = Obligacion(
                              id: 'O${now.millisecondsSinceEpoch}',
                              nombre:
                                  pagoSeleccionado?.name.name ?? 'Obligación',
                              periodo:
                                  '${now.month.toString().padLeft(2, '0')}/${now.year}',
                              fechaPago:
                                  '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                              acreedorId: widget.acreedor.id!,
                              pagoId: pagoSeleccionado!.id!,
                              finalizada: false,
                            );
                            // Podríamos usar la descripcion en 'nombre' o en otro campo; para simplicidad lo ponemos en nombre si existe
                            if (_descripcionController.text.isNotEmpty) {
                              // no cambiar id pero ajustar nombre a descripción corta
                            }
                            Navigator.pop(context, nuevo);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: const Text('Agregar Obligación'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );*/
  }

  Future<PaymentWithSharedDuty?> _openPagoSelector(BuildContext context) async {
    // Mostrar un diálogo modal con un loader mientras se cargan los pagos
    showDialog(
      context: context,
      barrierDismissible: false, // impide cerrarlo tocando fuera
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Esperar la carga
    final pagosCargados = await fetchUndonePayments();

    // Cerrar el diálogo de carga
    if (context.mounted) Navigator.pop(context);

    // Verificar si hay pagos
    if (pagosCargados.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se encontraron pagos disponibles")),
        );
      }
      return null;
    }

    // Mostrar el modal con los datos ya cargados
    return showModalBottomSheet<PaymentWithSharedDuty>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Seleccionar Pago',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 320,
                  child: ListView.separated(
                    itemCount: pagosCargados.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final p = pagosCargados[i];
                      return ListTile(
                        title: Text(p.name.name),
                        subtitle: Text(
                          'Monto: \$${p.amount.toStringAsFixed(2)} '
                          '• Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/'
                          '${p.deadline.month.toString().padLeft(2, '0')}/'
                          '${p.deadline.year}',
                        ),
                        onTap: () => Navigator.pop(ctx, p),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   setState(() => _isLoading = true);

  //   // Esperamos la carga y guardamos el resultado en una variable local
  //   final pagosCargados = await fetchUndonePayments();

  //   setState(() => _isLoading = false);

  //   // Verificamos que existan resultados
  //   if (pagosCargados == null || pagosCargados.isEmpty) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No hay pagos disponibles")),
  //       );
  //     }
  //     return null;
  //   }

  //   // Mostramos el modal con los datos ya cargados
  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagosCargados.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagosCargados[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                         'Monto: \$${p.amount.toStringAsFixed(2)} '
  //                         '• Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/'
  //                         '${p.deadline.month.toString().padLeft(2, '0')}/'
  //                         '${p.deadline.year}',
  //                       ),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                 onPressed: () => Navigator.pop(ctx),
  //                 child: const Text('Cancelar'),
  //               ),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   // 1️⃣ Mostramos un loader general mientras cargan los pagos
  //   setState(() => _isLoading = true);

  //   await fetchUndonePayments(); // Esperamos a que los pagos se carguen

  //   setState(() => _isLoading = false);

  //   // 2️⃣ Una vez cargados, recién mostramos el modal
  //   if (payments.isEmpty) {
  //     // Mostramos un mensaje si no hay pagos disponibles
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No hay pagos disponibles")),
  //       );
  //     }
  //     return null;
  //   }

  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       final pagos = payments;

  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagos.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagos[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                           'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                   onPressed: () => Navigator.pop(ctx),
  //                   child: const Text('Cancelar')),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   setState(() => _isLoading = true);
  //   await fetchUndonePayments(); // 🔹 solo ahora se cargan los pagos
  //   setState(() => _isLoading = false);

  //   final pagos = payments;

  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: _isLoading
  //               ? const Center(
  //                   child: Padding(
  //                     padding: EdgeInsets.all(20),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 )
  //               : Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       margin: const EdgeInsets.symmetric(vertical: 8),
  //                       height: 5,
  //                       width: 40,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey[400],
  //                           borderRadius: BorderRadius.circular(4)),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text('Seleccionar Pago',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 16)),
  //                     const SizedBox(height: 8),
  //                     if (pagos.isEmpty)
  //                       const Padding(
  //                         padding: EdgeInsets.all(16),
  //                         child: Text("No hay pagos disponibles"),
  //                       )
  //                     else
  //                       SizedBox(
  //                         height: 320,
  //                         child: ListView.separated(
  //                           itemCount: pagos.length,
  //                           separatorBuilder: (_, __) => const Divider(),
  //                           itemBuilder: (context, i) {
  //                             final p = pagos[i];
  //                             return ListTile(
  //                               title: Text(p.name.name),
  //                               subtitle: Text(
  //                                   'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                               onTap: () => Navigator.pop(ctx, p),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     const SizedBox(height: 8),
  //                     OutlinedButton(
  //                         onPressed: () => Navigator.pop(ctx),
  //                         child: const Text('Cancelar')),
  //                     const SizedBox(height: 12),
  //                   ],
  //                 ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   //final pagos = repo.pagos;
  //   // await fetchUndonePayments();
  //   setState(() {
  //     fetchUndonePayments();
  //   });
  //   final pagos = payments;
  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagos.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagos[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                           'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                   onPressed: () => Navigator.pop(ctx),
  //                   child: const Text('Cancelar')),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

////////////////////

// ------------------- SCREEN: NUEVA OBLIGACION (FORM) -------------------
class EditarObligacionScreen extends StatefulWidget {
  final SharedDuty obligacion;
  //final Acreedor acreedor; // bloqueado en el formulario
  //final Creditor acreedor;

  const EditarObligacionScreen({super.key, required this.obligacion});

  @override
  State<EditarObligacionScreen> createState() => _EditarObligacionScreenState();
}

class _EditarObligacionScreenState extends State<EditarObligacionScreen> {
  final repo = DataRepository.instance;
  final TextEditingController _descripcionController = TextEditingController();
  final HomeServices homeServices = HomeServices();
  final SharedDutyServices sharedDutyServices = SharedDutyServices();
  // Pago? pagoSeleccionado;
  PaymentWithSharedDuty? pagoSeleccionado;
  bool _isLoading = false;

  //List<Payment> payments = [];
  List<PaymentWithSharedDuty> payments = [];

  // Future<void> fetchUndonePayments() async {
  //   fetchData<Payment>(
  //     // context: null,
  //     fetchFunction: homeServices.fetchUndonePayments,
  //     onStart: () => setState(() => _isLoading = true),
  //     // onStart: () {
  //     //   _isLoading = true;
  //     //   notifyListeners();
  //     // },
  //     onSuccess: (items) => setState(() {
  //       payments = items;
  //       // _foundPayments = items;
  //     }),
  //     // onSuccess: (items) {
  //     //   payments = items;
  //     //   _foundPayments = items;
  //     //   notifyListeners();
  //     // },
  //     onComplete: () => setState(() => _isLoading = false),
  //     // onComplete: () {
  //     //   _isLoading = false;
  //     //   notifyListeners();
  //     // },
  //   );
  // }

  Future<List<PaymentWithSharedDuty>> fetchUndonePayments() async {
    final result = await homeServices.fetchUndonePaymentsWithSD();
    // setState(() {
    //   payments =
    //       result.where((element) => !element.sharedDuty.hasSharedDuty).toList();
    // });
    // return result;
    /*  final filtered = result
        .where(
          (e) => !(e.sharedDuty.hasSharedDuty == true),
        )
        .toList();*/

    setState(() {
      // payments = filtered;
      payments = result;
      pagoSeleccionado = payments
          .where((element) => element.id! == widget.obligacion.payment.id!)
          .first;
    });

    // return filtered;
    return payments;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUndonePayments();

    /* pagoSeleccionado = payments
        .where((element) => element.id! == widget.obligacion.payment.id!)
        .first;*/
  }

  void _confirmAdd() {
    // debugPrint(esEdicion.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar creación'),
        content: Text("¿Desea agregar la obligación compartida?"),
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
            onPressed: () => _addSharedDuty(),
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _addSharedDuty() async {
    await sharedDutyServices.addSharedDuty(
        creditor: widget.obligacion.creditor.id!,
        payment: pagoSeleccionado!.id!,
        description: _descripcionController.text != ""
            ? _descripcionController.text
            : "-");
  }

  @override
  Widget build(BuildContext context) {
    final nombreIngresado =
        _descripcionController.text.isNotEmpty; // optional; we won't require it
    final puedeAgregar =
        // pagoSeleccionado != null && widget.acreedor.id.isNotEmpty;
        pagoSeleccionado != null && widget.obligacion.creditor.id!.isNotEmpty;

    return TitleLayout(
      title: 'Editar Obligación',
      child:
          //Padding(
          //  padding: const EdgeInsets.all(16),
          //child:
          Column(
        children: [
          // Acreedor bloqueado (solo muestra el seleccionado)
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Acreedor',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    // child: Text(widget.acreedor.nombre,
                    child: Text(widget.obligacion.creditor.name,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                const Icon(Icons.lock),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Pago (abre modal con listado)
          GestureDetector(
            onTap: () async {
              //  await fetchUndonePayments();
              final pago = await _openPagoSelector(context);
              if (pago != null) {
                setState(() {
                  pagoSeleccionado = pago;
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pago (seleccionar)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pagoSeleccionado != null
                          ? "${pagoSeleccionado!.name.name} — \$${pagoSeleccionado!.amount.toStringAsFixed(2)}"
                          : 'Tocar para seleccionar un pago',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Descripción opcional
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder()),
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'))),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: puedeAgregar
                      ? _confirmAdd
                      // () {
                      //     // crear nueva obligación y regresar
                      //     final now = DateTime.now();
                      //     final nuevo = Obligacion(
                      //       id: 'O${now.millisecondsSinceEpoch}',
                      //       nombre: pagoSeleccionado?.name.name ?? 'Obligación',
                      //       periodo:
                      //           '${now.month.toString().padLeft(2, '0')}/${now.year}',
                      //       fechaPago:
                      //           '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                      //       acreedorId: widget.acreedor.id!,
                      //       pagoId: pagoSeleccionado!.id!,
                      //       finalizada: false,
                      //     );
                      //     // Podríamos usar la descripcion en 'nombre' o en otro campo; para simplicidad lo ponemos en nombre si existe
                      //     if (_descripcionController.text.isNotEmpty) {
                      //       // no cambiar id pero ajustar nombre a descripción corta
                      //     }
                      //     Navigator.pop(context, nuevo);
                      //   }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalVariables.secondaryColor),
                  child: const Text('Editar Obligación'),
                ),
              ),
            ],
          )
        ],
      ),
      //),
    );

/*
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Obligación')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Acreedor bloqueado (solo muestra el seleccionado)
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Acreedor',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      // child: Text(widget.acreedor.nombre,
                      child: Text(widget.acreedor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  const Icon(Icons.lock),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Pago (abre modal con listado)
            GestureDetector(
              onTap: () async {
                //  await fetchUndonePayments();
                final pago = await _openPagoSelector(context);
                if (pago != null) {
                  setState(() {
                    pagoSeleccionado = pago;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Pago (seleccionar)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pagoSeleccionado != null
                            ? "${pagoSeleccionado!.name.name} — \$${pagoSeleccionado!.amount.toStringAsFixed(2)}"
                            : 'Tocar para seleccionar un pago',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Descripción opcional
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder()),
              maxLines: 3,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'))),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: puedeAgregar
                        ? () {
                            // crear nueva obligación y regresar
                            final now = DateTime.now();
                            final nuevo = Obligacion(
                              id: 'O${now.millisecondsSinceEpoch}',
                              nombre:
                                  pagoSeleccionado?.name.name ?? 'Obligación',
                              periodo:
                                  '${now.month.toString().padLeft(2, '0')}/${now.year}',
                              fechaPago:
                                  '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                              acreedorId: widget.acreedor.id!,
                              pagoId: pagoSeleccionado!.id!,
                              finalizada: false,
                            );
                            // Podríamos usar la descripcion en 'nombre' o en otro campo; para simplicidad lo ponemos en nombre si existe
                            if (_descripcionController.text.isNotEmpty) {
                              // no cambiar id pero ajustar nombre a descripción corta
                            }
                            Navigator.pop(context, nuevo);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: const Text('Agregar Obligación'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );*/
  }

  Future<PaymentWithSharedDuty?> _openPagoSelector(BuildContext context) async {
    // Mostrar un diálogo modal con un loader mientras se cargan los pagos
    showDialog(
      context: context,
      barrierDismissible: false, // impide cerrarlo tocando fuera
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Esperar la carga
    final pagosCargados = await fetchUndonePayments();

    // Cerrar el diálogo de carga
    if (context.mounted) Navigator.pop(context);

    // Verificar si hay pagos
    if (pagosCargados.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se encontraron pagos disponibles")),
        );
      }
      return null;
    }

    // Mostrar el modal con los datos ya cargados
    return showModalBottomSheet<PaymentWithSharedDuty>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Seleccionar Pago',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 320,
                  child: ListView.separated(
                    itemCount: pagosCargados.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final p = pagosCargados[i];
                      return ListTile(
                        title: Text(p.name.name),
                        subtitle: Text(
                          'Monto: \$${p.amount.toStringAsFixed(2)} '
                          '• Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/'
                          '${p.deadline.month.toString().padLeft(2, '0')}/'
                          '${p.deadline.year}',
                        ),
                        onTap: () => Navigator.pop(ctx, p),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   setState(() => _isLoading = true);

  //   // Esperamos la carga y guardamos el resultado en una variable local
  //   final pagosCargados = await fetchUndonePayments();

  //   setState(() => _isLoading = false);

  //   // Verificamos que existan resultados
  //   if (pagosCargados == null || pagosCargados.isEmpty) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No hay pagos disponibles")),
  //       );
  //     }
  //     return null;
  //   }

  //   // Mostramos el modal con los datos ya cargados
  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagosCargados.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagosCargados[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                         'Monto: \$${p.amount.toStringAsFixed(2)} '
  //                         '• Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/'
  //                         '${p.deadline.month.toString().padLeft(2, '0')}/'
  //                         '${p.deadline.year}',
  //                       ),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                 onPressed: () => Navigator.pop(ctx),
  //                 child: const Text('Cancelar'),
  //               ),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   // 1️⃣ Mostramos un loader general mientras cargan los pagos
  //   setState(() => _isLoading = true);

  //   await fetchUndonePayments(); // Esperamos a que los pagos se carguen

  //   setState(() => _isLoading = false);

  //   // 2️⃣ Una vez cargados, recién mostramos el modal
  //   if (payments.isEmpty) {
  //     // Mostramos un mensaje si no hay pagos disponibles
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No hay pagos disponibles")),
  //       );
  //     }
  //     return null;
  //   }

  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       final pagos = payments;

  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagos.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagos[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                           'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                   onPressed: () => Navigator.pop(ctx),
  //                   child: const Text('Cancelar')),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   setState(() => _isLoading = true);
  //   await fetchUndonePayments(); // 🔹 solo ahora se cargan los pagos
  //   setState(() => _isLoading = false);

  //   final pagos = payments;

  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: _isLoading
  //               ? const Center(
  //                   child: Padding(
  //                     padding: EdgeInsets.all(20),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 )
  //               : Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       margin: const EdgeInsets.symmetric(vertical: 8),
  //                       height: 5,
  //                       width: 40,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey[400],
  //                           borderRadius: BorderRadius.circular(4)),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text('Seleccionar Pago',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 16)),
  //                     const SizedBox(height: 8),
  //                     if (pagos.isEmpty)
  //                       const Padding(
  //                         padding: EdgeInsets.all(16),
  //                         child: Text("No hay pagos disponibles"),
  //                       )
  //                     else
  //                       SizedBox(
  //                         height: 320,
  //                         child: ListView.separated(
  //                           itemCount: pagos.length,
  //                           separatorBuilder: (_, __) => const Divider(),
  //                           itemBuilder: (context, i) {
  //                             final p = pagos[i];
  //                             return ListTile(
  //                               title: Text(p.name.name),
  //                               subtitle: Text(
  //                                   'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                               onTap: () => Navigator.pop(ctx, p),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     const SizedBox(height: 8),
  //                     OutlinedButton(
  //                         onPressed: () => Navigator.pop(ctx),
  //                         child: const Text('Cancelar')),
  //                     const SizedBox(height: 12),
  //                   ],
  //                 ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<Payment?> _openPagoSelector(BuildContext context) async {
  //   //final pagos = repo.pagos;
  //   // await fetchUndonePayments();
  //   setState(() {
  //     fetchUndonePayments();
  //   });
  //   final pagos = payments;
  //   return showModalBottomSheet<Payment>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 height: 5,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[400],
  //                     borderRadius: BorderRadius.circular(4)),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('Seleccionar Pago',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               const SizedBox(height: 8),
  //               SizedBox(
  //                 height: 320,
  //                 child: ListView.separated(
  //                   itemCount: pagos.length,
  //                   separatorBuilder: (_, __) => const Divider(),
  //                   itemBuilder: (context, i) {
  //                     final p = pagos[i];
  //                     return ListTile(
  //                       title: Text(p.name.name),
  //                       subtitle: Text(
  //                           'Monto: \$${p.amount.toStringAsFixed(2)} • Fecha: ${p.deadline.day.toString().padLeft(2, '0')}/${p.deadline.month.toString().padLeft(2, '0')}/${p.deadline.year}'),
  //                       onTap: () => Navigator.pop(ctx, p),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               OutlinedButton(
  //                   onPressed: () => Navigator.pop(ctx),
  //                   child: const Text('Cancelar')),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}



////////////////////////
///
///
///
///
///
///*/
///
///