import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/loader.dart';
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

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
      isLoading: _isLoading,
      title: 'Categorías',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar categoría...",
      child: ConditionalListView(
        items: categories,
        foundItems: _foundCategories,
        loader: const Loader(),
        emptyMessage: "¡No existen categorías para mostrar!",
        itemBuilder: (context, category) => CategoryCard(category: category),
        //separatorBuilder: (context, _) => const Divider(),
      ),
    );
  }
}
