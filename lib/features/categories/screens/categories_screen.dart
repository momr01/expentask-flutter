import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/models/category/category.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category>? categories;
  List<Category> _foundCategories = [];
  final TextEditingController _searchController = TextEditingController();
  final CategoriesServices categoriesServices = CategoriesServices();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  fetchAllCategories() async {
    setState(() {
      _isLoading = true;
    });
    categories = await categoriesServices.fetchCategories();

    setState(() {
      _foundCategories = categories!;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Category> results = [];
    if (enteredKeyword.isEmpty) {
      results = categories!;
    } else {
      results = categories!
          .where((category) => category.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        drawer: const CustomDrawer(),
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
                    const MainTitle(title: 'Categorías'),
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
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text(
                    //             'filtros'.toUpperCase(),
                    //             style: const TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 17),
                    //           ),
                    //           const SizedBox(
                    //             width: 10,
                    //           ),
                    //           Card(
                    //             color: GlobalVariables.historicalFilterColor,
                    //             elevation: 0,
                    //             shape: RoundedRectangleBorder(
                    //               side: const BorderSide(
                    //                 color: GlobalVariables.historicalFilterColor,
                    //               ),
                    //               borderRadius: BorderRadius.circular(50),
                    //             ),
                    //             child: SizedBox(
                    //               child: Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 5, horizontal: 10),
                    //                   child: Text(
                    //                       widget.finalFilter.length.toString(),
                    //                       textAlign: TextAlign.center,
                    //                       style: const TextStyle(
                    //                           color: Colors.white,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 16))),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           _navigateToFilterScreen(context);
                    //         },
                    //         child: Image.asset(
                    //           'assets/images/filter.png',
                    //           width: 25,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // payments == null
              //     ? const Loader()
              //     : payments!.isEmpty
              //         ? const Text('No existen pagos para mostrar!')
              //         : _foundPayments.isEmpty
              //             ? const Text(
              //                 'No existen resultados a su búsqueda!',
              //                 style: TextStyle(fontSize: 16),
              //               )
              //             : Expanded(
              //                 child: ListView.builder(
              //                     itemCount: _foundPayments.length,
              //                     itemBuilder: (context, index) {
              //                       return HistoricalItemCard(
              //                         payment: _foundPayments[index],
              //                       );
              //                     }),
              //               )
            ],
          ),
        ));
  }
}
