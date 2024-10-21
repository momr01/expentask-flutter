import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_dialog.dart';
import 'package:payments_management/common/widgets/modals/modal_form/model.form_input.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/features/categories/widgets/category_card.dart';
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
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<FormInput> _addControllers = [];
  final CategoriesServices categoriesServices = CategoriesServices();
  final _addCategoryKey = GlobalKey<FormState>();

  //FloatBtnClass floatBtn = FloatBtnClass(withFloatBtn: withFloatBtn, loadFloatBtn: loadFloatBtn);

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
    // floatBtn
    _addControllers
        .add(FormInput("Nombre:", _nameController, "Escriba un nombre"));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  fetchAllCategories() async {
    fetchData(
        context: context,
        fetchFunction: categoriesServices.fetchCategories,
        onStart: () => setState(() => _isLoading = true),
        onSuccess: (items) => setState(() {
              categories = items;
              _foundCategories = items;
            }),
        onComplete: () => setState(() => _isLoading = false));
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundCategories = runFilter(
          enteredKeyword,
          categories!,
          (category) => category.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()));
    });
  }

  void addNewCategory() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalFormDialog(
              controllers: _addControllers,
              title: "agregar categoría",
              actionBtnText: "agregar",
              modalFormKey: _addCategoryKey,
              onComplete: () {
                debugPrint("kkkkkkkk");
                debugPrint(_nameController.text);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
      isLoading: _isLoading,
      title: 'Categorías',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar categoría...",
      // withFloatBtn: ,
      withFloatBtn: true,
      onTapFloatBtn: addNewCategory,
      child: ConditionalListView(
        items: categories,
        foundItems: _foundCategories,
        loader: const Loader(),
        emptyMessage: "¡No existen categorías para mostrar!",
        itemBuilder: (context, category) {
          return CategoryCard(category: category);
        },
        separatorBuilder: (context, _) => const SizedBox(
          height: 10,
        ),
        paddingEnd: 30,
      ),
    );
  }
}
