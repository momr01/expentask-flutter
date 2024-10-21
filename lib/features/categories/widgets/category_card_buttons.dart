import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_icons.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_dialog.dart';
import 'package:payments_management/common/widgets/modals/modal_form/model.form_input.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/category/category.dart';

class CategoryCardButtons extends StatefulWidget {
  final Category category;
  const CategoryCardButtons({super.key, required this.category});

  @override
  State<CategoryCardButtons> createState() => _CategoryCardButtonsState();
}

class _CategoryCardButtonsState extends State<CategoryCardButtons> {
  final TextEditingController _nameController = TextEditingController();
  final List<FormInput> _controllers = [];
  final _editCategoryKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = capitalizeFirstLetter(widget.category.name);
    _controllers
        .add(FormInput("Nombre:", _nameController, "Escriba un nombre"));
  }

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].controller.dispose();
    }
    super.dispose();
  }

  void editCategory() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalFormDialog(
              controllers: _controllers,
              title: "editar categoría",
              actionBtnText: "editar",
              modalFormKey: _editCategoryKey,
              onComplete: () {
                debugPrint("kkkkkkkk");
                debugPrint(_nameController.text);
              },
            ));
  }

  void deleteCategory() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: () async {},
              confirmText: 'eliminar',
              confirmColor: Colors.red,
              middleText: 'eliminar',
              endText: 'la categoría',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Row(children: [
        CustomButtonIcons(
          onTap: editCategory,
          delete: false,
          backColor: Colors.grey.shade300,
        ),
        CustomButtonIcons(
          onTap: deleteCategory,
          delete: true,
          backColor: Colors.grey.shade300,
        )
      ]),
    );
  }
}
