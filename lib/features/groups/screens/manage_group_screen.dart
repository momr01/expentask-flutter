// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/groups/services/groups_services.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/modal_select_names.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';
import 'package:payments_management/models/name/payment_name.dart';

class ManageGroupScreen extends StatefulWidget {
  static const String routeName = '/edit-group';
  final Group group;
  final List<GroupNameCheckbox>? namesList;
  const ManageGroupScreen({Key? key, required this.group, this.namesList})
      : super(key: key);

  @override
  State<ManageGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<ManageGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _manageGroupFormKey = GlobalKey<FormState>();
  final GroupsServices groupsServices = GroupsServices();
  List<PaymentName> payments = [];
  List<GroupNameCheckbox> finalNamesList = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name;
    payments = widget.group.id != null ? widget.group.paymentNames : [];

    updateFinalNamesList();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void updateFinalNamesList() {
    if (payments != []) {
      for (var payment in payments) {
        finalNamesList
            .add(GroupNameCheckbox(id: payment.id, name: payment.name));
      }
    }
    setState(() {});
  }

  void validateForm() {
    if (_manageGroupFormKey.currentState!.validate()) {
      // editGroup();
      openModalConfirmation();
    }
  }

  void openModalConfirmation() async {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ModalConfirmation(
        onTap: widget.group.id != null ? editGroup : addGroup,
        confirmText: widget.group.id != null ? 'editar' : 'registrar',
        confirmColor: widget.group.id != null
            ? GlobalVariables.completeButtonColor!
            : Colors.blue,
        middleText: widget.group.id != null ? 'editar' : 'registrar',
        endText: 'el nuevo grupo',
      ),
    );
  }

  Future<void> addGroup() async {
    // debugPrint('editar');
    // debugPrint(_nameController.text);

    // for (var payment in finalNamesList) {
    //   debugPrint(payment.name);
    // }

    //  openModalConfirmation();

    await groupsServices.addGroup(
        name: _nameController.text, paymentNames: finalNamesList);
  }

  Future<void> editGroup() async {
    // debugPrint('editar');
    // debugPrint(_nameController.text);

    // for (var payment in finalNamesList) {
    //   debugPrint(payment.name);
    // }

    // openModalConfirmation();
    await groupsServices.editGroup(
        id: widget.group.id!,
        name: _nameController.text,
        paymentNames: finalNamesList);
  }

  Future<void> openPaymentNamesModal() async {
    final result = await showDialog<List>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalSelectNames(
              selectedNames: finalNamesList,
            ));

    if (!context.mounted) return;
    setState(() {
      finalNamesList.clear();
    });

    //debugPrint(result.toString());
    if (result != null && result.isNotEmpty) {
      // debugPrint('Nombres seleccionados: ${result.join(', ')}');
      debugPrint(result.length.toString());
      // Realiza acciones con los nombres seleccionados
      setState(() {
        for (var element in result) {
          finalNamesList.add(element);
        }
      });

      //setState(() {});
    } else {
      debugPrint('No se seleccionó ningún nombre');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              MainTitle(
                  title:
                      '${widget.group.id == null ? "Crear" : "Editar"} Grupo'),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _manageGroupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nombre:'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            modal: true,
                            controller: _nameController,
                            hintText: 'Ingrese el nombre del grupo'),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Nombres de Pagos:'),
                            GestureDetector(
                                onTap: openPaymentNamesModal,
                                child: Icon(
                                  Icons.edit,
                                  color: GlobalVariables.completeButtonColor,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 250,
                            decoration: BoxDecoration(
                                color: GlobalVariables.greyBackgroundColor,
                                border: Border.all(color: Colors.black38),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 5,
                                ),
                                itemBuilder: (context, index) => Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Center(
                                      child: Text(
                                    //widget.group.paymentNames[index].name,
                                    finalNamesList[index].name!,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                                ),
                                // itemCount: widget.group.paymentNames.length,
                                itemCount: finalNamesList.length,
                              ),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        finalNamesList.isEmpty
                            //_manageGroupFormKey.currentState!.validate()
                            ? const SizedBox()
                            : CustomButton(
                                text: widget.group.id != null
                                    ? 'EDITAR'
                                    : "REGISTRAR",
                                onTap: validateForm,
                                color: GlobalVariables.secondaryColor,
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () => fromEditGroupToGroupDetails(context),
                            child: const Text(
                              'CANCELAR',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black54),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
