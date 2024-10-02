// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_green_disabled.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_icons.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/common/widgets/modal_confirmation.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/names/utils/names_utils.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class ModalNameDetails extends StatefulWidget {
  final PaymentName name;
  const ModalNameDetails({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<ModalNameDetails> createState() => _ModalNameDetailsState();
}

class _ModalNameDetailsState extends State<ModalNameDetails> {
  final NamesServices namesServices = NamesServices();
  bool isLoading = false;

  // void navigateToFormNameScreen(BuildContext context, PaymentName name) {
  //   Navigator.pushNamed(context, FormManageNameScreen.routeName,
  //       arguments: name);
  // }

  void disableName() async {
    namesServices.disableName(context: context, nameId: widget.name.id!);
  }

  void openDeleteConfirmation(BuildContext context) async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: disableName,
              confirmText: 'eliminar',
              confirmColor: Colors.red,
              middleText: 'eliminar',
              endText: 'el nombre',
            ));
  }

  void _prepareDataToSendToForm() async {
    setState(() {
      isLoading = true;
    });
    // getDataToForm(context, widget.name);
    List<Category> categories = [];
    List<TaskCode> taskCodes = [];

    categories = await categoriesServices.fetchCategories(context: context);

    if (categories.isEmpty) {
      errorModal(
        context: context,
        description:
            "Debe crear al menos una categoría, antes de agregar un nombre.",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 1, (route) => true);
        },
      );
    } else {
      taskCodes = await tasksServices.fetchTaskCodes();
      if (taskCodes.isEmpty) {
        errorModal(
          context: context,
          description:
              "Debe crear al menos un código, antes de agregar un nombre.",
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, arguments: 1, (route) => true);
          },
        );
      } else {
        //navigateToFormEditPayment(context, payment!, names, taskCodes);
        navigateToFormNameScreen(context, widget.name, categories, taskCodes);
      }
    }
    // navigateToFormEditPayment(context, payment!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        icon: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close_sharp,
                  color: Theme.of(context).colorScheme.primary))
        ]),
        iconPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: Column(children: [
              Center(
                  child: Text(
                textAlign: TextAlign.center,
                capitalizeFirstLetter(widget.name.name),
                style: const TextStyle(
                    fontSize: 33.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              )),
            ])),
          ]),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const Text('Categoría:', style: TextStyle(fontSize: 20)),
            Flexible(
                child: ColorRoundedItem(
              colorBackCard: Colors.purple,
              colorBorderCard: Colors.purple,
              text: capitalizeFirstLetter(widget.name.category.name),
              colorText: Colors.white,
              sizeText: 20,
            )),
          ]),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              isLoading
                  ? const CustomButtonGreenDisabled()
                  : CustomButtonIcons(
                      // onTap: () => navigateToFormNameScreen(context, widget.name),
                      onTap: _prepareDataToSendToForm,
                      delete: false),
              const SizedBox(
                width: 20,
              ),
              CustomButtonIcons(
                  onTap: () => openDeleteConfirmation(context), delete: true),
            ],
          ),
        ]));
  }
}
