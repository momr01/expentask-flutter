import 'package:flutter/material.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/models/category/category.dart';

class CategoriesDialog extends StatefulWidget {
  const CategoriesDialog({super.key});

  @override
  State<CategoriesDialog> createState() => _CategoriesDialogState();
}

class _CategoriesDialogState extends State<CategoriesDialog> {
  List<Category>? categories;
  List<Category> _foundCategories = [];
  List<Category> _test = [];
  bool _isLoading = false;

  final CategoriesServices categoriesServices = CategoriesServices();

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  fetchAllCategories() async {
    fetchData(
        //  context: context,
        fetchFunction: categoriesServices.fetchCategories,
        onStart: () => setState(() => _isLoading = true),
        onSuccess: (items) => setState(() {
              categories = items;
              _foundCategories = items;
            }),
        onComplete: () => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 300, // 🔹 altura fija
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selecciona una categoría',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),
            /* _isLoading
                ? CircularProgressIndicator()
                : _foundCategories.isEmpty
                    ? Center(
                        child: Text("¡No existen categorías para mostrar!"))
                    :*/
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _foundCategories.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            "¡No existen categorías para mostrar!",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    :

                    // 🔹 Scroll interno
                    Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(8),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              //  children: options.map((opt) {
                              children: _foundCategories.map((opt) {
                                return ListTile(
                                  title: Text(capitalizeFirstLetter(opt.name)),
                                  onTap: () => Navigator.pop(context, opt.name),
                                );
                              }).toList(),
                              //   children: ,
                            ),
                          ),
                        ),
                      ),
            /*  Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: options.map((opt) {
                      return ListTile(
                        title: Text(opt),
                        onTap: () => Navigator.pop(context, opt),
                      );
                    }).toList(),
                  ),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
