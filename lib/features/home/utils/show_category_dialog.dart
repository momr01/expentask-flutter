import 'package:flutter/material.dart';
import 'package:payments_management/features/home/widgets/categories_dialog.dart';

Future<String?> showCategoryDialog(BuildContext context) async {
  // final CategoriesServices categoriesServices = CategoriesServices();
  // List<Category> categories = await categoriesServices.fetchCategories();

  // debugPrint(categories.toString());

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      // final options = [
      //   'Bonos de Sueldo',
      //   'Varios',
      //   'Expensas',
      //   'telefonía celular',
      //   'compras',
      //   'seguros',
      //   'servicios básicos',
      //   'viajes'
      // ]; // ejemplo largo

      /* return Dialog(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Selecciona una categoría',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 5),

              // 🔹 Scroll interno
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: options.map((opt) {
                        return ListTile(
                          title: Text(opt),
                          onTap: () => Navigator.pop(context, opt),
                        );
                      }).toList(),
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
      );*/

      return CategoriesDialog();
    },
  );
}
