// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/modal_select_names.dart';
import 'package:payments_management/models/group/group.dart';

class EditGroupScreen extends StatefulWidget {
  static const String routeName = '/edit-group';
  final Group group;
  const EditGroupScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void editGroup() {
    debugPrint('editar');
  }

  void openPaymentNamesModal() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalSelectNames());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              const MainTitle(title: 'Editar Grupo'),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nombre:'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Center(
                                    child: Text(
                                  widget.group.paymentNames[index].name,
                                  style: const TextStyle(fontSize: 15),
                                )),
                              ),
                              itemCount: widget.group.paymentNames.length,
                            ),
                          )),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomButton(
                        text: 'EDITAR',
                        onTap: editGroup,
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
                            style:
                                TextStyle(fontSize: 25, color: Colors.black54),
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
            ],
          ),
        ));
  }
}
