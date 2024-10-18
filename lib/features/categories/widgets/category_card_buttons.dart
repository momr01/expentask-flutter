import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_icons.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_dialog.dart';
import 'package:payments_management/models/category/category.dart';

class CategoryCardButtons extends StatefulWidget {
  final Category category;
  const CategoryCardButtons({super.key, required this.category});

  @override
  State<CategoryCardButtons> createState() => _CategoryCardButtonsState();
}

class _CategoryCardButtonsState extends State<CategoryCardButtons> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  //final List<TextEditingController> _controllers = [];
  final List<FormInput> _controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* _controllers.add(_controller1);
    _controllers.add(_controller2);
    _controllers.add(_controller3);
    _controllers.add(_controller4);*/
    _controllers.add(FormInput("cont1", _controller1, "cont1"));
    _controllers.add(FormInput("cont2", _controller2, "cont2"));
    _controllers.add(FormInput("cont3", _controller3, "cont3"));
    _controllers.add(FormInput("cont4", _controller4, "cont4"));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  void editCategory() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalFormDialog(
              controllers: _controllers,
              title: "editar categoría",
              form: Text('hola'),
              actionBtnText: "editar",
              onComplete: () {
                debugPrint("kkkkkkkk");
                debugPrint(_controller1.text);
                debugPrint(_controller2.text);
                debugPrint(_controller3.text);
                debugPrint(_controller4.text);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Row(children: [
        CustomButtonIcons(
          onTap: () {
            debugPrint(widget.category.id!);
            editCategory();
          },
          delete: false,
          backColor: Colors.grey.shade300,
        ),
        CustomButtonIcons(
          onTap: () {
            debugPrint(widget.category.id!);
          },
          delete: true,
          backColor: Colors.grey.shade300,
        )
      ]),
    );
  }
}
