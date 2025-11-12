import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/float_btn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/names/providers/names_provider.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/names/utils/names_utils.dart';
import 'package:payments_management/features/names/widgets/name_card.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:provider/provider.dart';

class NamesScreen extends StatefulWidget {
  static const String routeName = '/names';
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
/*  List<PaymentName>? names;
  List<PaymentName> _foundNames = [];

  final TextEditingController _searchController = TextEditingController();
  final NamesServices namesServices = NamesServices();

  bool _isLoading = false;
  bool _newNameScreenLoading = false;

  @override
  void initState() {
    super.initState();
    //fetchPaymentNames();

   /* Future.microtask(() {
      final provider = Provider.of<NamesProvider>(context, listen: false);
      provider.fetchNames(); // 👈 solo carga la primera vez
    });*/
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchPaymentNames() {
    fetchData<PaymentName>(
        // context: context,
        fetchFunction: namesServices.fetchPaymentNames,
        onSuccess: (items) => setState(() {
              names = items;
              _foundNames = items;
            }),
        onStart: () => setState(() => _isLoading = true),
        onComplete: () => setState(() => _isLoading = false));
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundNames = runFilter<PaymentName>(
        keyword,
        names!,
        (name) => name.name.toLowerCase().contains(keyword.toLowerCase()),
      );
    });

    for (var element in _foundNames) {
      debugPrint(element.name);
    }
  }

  void _prepareDataToSendToForm() async {
    setState(() {
      _newNameScreenLoading = true;
    });
    await getDataToForm(
        context,
        PaymentName(
            name: "name",
            isActive: false,
            category: Category(name: "", isActive: false)));

    setState(() {
      _newNameScreenLoading = false;
    });
  }

  Future<void> _refreshData() async {
    fetchPaymentNames();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
   // final provider = Provider.of<NamesProvider>(context);

    return
        //RefreshIndicator(
        // onRefresh: _refreshData,
        // child:

        TitleSearchLayout(
      refreshData: _refreshData,
      isMain: true,
        isLoading: _isLoading,
     // isLoading: provider.isLoading,
      title: 'Nombres creados',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar nombre...",
      withFloatBtn: true,
      //loadFloatBtn: _newNameScreenLoading,
      floatBtn: FloatBtn(
        // loadFloatBtn: true,
        loadFloatBtn: _newNameScreenLoading,
        onTapFloatBtn: _prepareDataToSendToForm,
      ),

/*
        floatBtn: SizedBox(
          height: 80,
          width: 80,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: GlobalVariables.historicalPending,
            foregroundColor: Colors.white,
            onPressed: _prepareDataToSendToForm,
            child: _newNameScreenLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.add,
                    size: 40,
                  ),
          ),
        ),

*/

      //  onTapFloatBtn: _prepareDataToSendToForm,
      child: Flexible(
        child: Column(
          children: [
            ConditionalListView(
               items: _foundNames,
               foundItems: _foundNames,
              // items: provider.names,
              // foundItems: provider.names,
              loader: const Loader(),
              emptyMessage: "¡No existen nombres para mostrar!",
              itemBuilder: (context, name) => NameCard(name: name),
            ),
          ],
        ),
      ),
    );
    // );
  }*/

  final TextEditingController _searchController = TextEditingController();
  bool _newNameScreenLoading = false;
  late ScrollController _scrollController;

  bool _didRestoreScroll = false;

  /*@override
  void initState() {
    super.initState();

    // 👇 Solo se carga si no se hizo antes
    Future.microtask(() {
      Provider.of<NamesProvider>(context, listen: false).fetchNames();
    });
  }*/
  /*@override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    Future.microtask(() {
      final provider = Provider.of<NamesProvider>(context, listen: false);
      provider.fetchNames();

      // 👇 restauramos el texto si ya había filtro aplicado
      _searchController.text = provider.lastSearch;

      // 👇 reaplicamos filtro si corresponde
      if (provider.lastSearch.isNotEmpty) {
        provider.applyLastSearch();
      }

      // 👇 Restaurar posición guardada
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.scrollOffset > 0 &&
            _scrollController.hasClients &&
            _scrollController.position.maxScrollExtent >=
                provider.scrollOffset) {
          _scrollController.jumpTo(provider.scrollOffset);
        }
      });
       });

      // 🔹 Escuchar movimiento para guardar posición
      /* _scrollController.addListener(() {
      final provider = Provider.of<NamesProvider>(context, listen: false);
      provider.setScrollOffset(_scrollController.offset);
    });*/

       final provider = Provider.of<NamesProvider>(context, listen: false);
    _scrollController = ScrollController(
      initialScrollOffset: provider.scrollOffset,
    );

      _scrollController.addListener(() {
        provider.setScrollOffset(_scrollController.offset);
      });
   // });
  }*/

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    Future.microtask(() {
      final provider = Provider.of<NamesProvider>(context, listen: false);
      provider.fetchNames();

      // 👇 restauramos el texto
      _searchController.text = provider.lastSearch;

      // 👇 reaplicamos filtro si corresponde
      if (provider.lastSearch.isNotEmpty) {
        provider.applyLastSearch();
      }

      // 👇 restauramos scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.scrollOffset > 0 &&
            _scrollController.hasClients &&
            _scrollController.position.maxScrollExtent >=
                provider.scrollOffset) {
          _scrollController.jumpTo(provider.scrollOffset);
        }
      });
    });

    /*  _scrollController.addListener(() {
      Provider.of<NamesProvider>(context, listen: false)
          .setScrollOffset(_scrollController.offset);
    });*/
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        Provider.of<NamesProvider>(context, listen: false)
            .setScrollOffset(_scrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _runFilter(String keyword) {
    Provider.of<NamesProvider>(context, listen: false).filter(keyword);
  }

  void _prepareDataToSendToForm() async {
    setState(() => _newNameScreenLoading = true);
    await getDataToForm(
        context,
        PaymentName(
          name: "name",
          isActive: false,
          category: Category(name: "", isActive: false),
        ),
        _searchController);
    setState(() => _newNameScreenLoading = false);
  }

  /*Future<void> _refreshData(BuildContext context) async {
    await Provider.of<NamesProvider>(context, listen: false).refresh();
    _searchController.clear();
  }*/

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<NamesProvider>(context, listen: false).refresh();
    _searchController.clear();
    Provider.of<NamesProvider>(context, listen: false).clearFilter();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NamesProvider>(context);

    /*  if (!provider.isLoading && !_didRestoreScroll) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.jumpTo(provider.scrollOffset);
    _didRestoreScroll = true;
  });
}*/
    // Restaurar scroll solo la primera vez que termina de cargar
    if (!provider.isLoading &&
        _scrollController.hasClients &&
        !_didRestoreScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target = provider.scrollOffset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
        _scrollController.jumpTo(target);
        _didRestoreScroll = true; // 👈 evita que lo haga más de una vez
      });
    }

    return TitleSearchLayout(
      refreshData: () => _refreshData(context),
      isMain: true,
      isLoading: provider.isLoading,
      title: 'Nombres creados',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar nombre...",
      withFloatBtn: true,
      floatBtn: FloatBtn(
        loadFloatBtn: _newNameScreenLoading,
        onTapFloatBtn: _prepareDataToSendToForm,
      ),
      child: Flexible(
        child: Column(
          children: [
            ConditionalListView(
              key: const PageStorageKey('NamesListScroll'),
              controller: _scrollController, // 👈 importante
              items: provider.filteredNames,
              foundItems: provider.filteredNames,
              loader: const Loader(),
              emptyMessage: "¡No existen nombres para mostrar!",
              itemBuilder: (context, name) => NameCard(
                name: name,
                searchController: _searchController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
