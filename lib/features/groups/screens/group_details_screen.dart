// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_icons.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/groups/services/groups_services.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/group_logo.dart';
import 'package:payments_management/models/group/group.dart';

class GroupDetailsScreen extends StatefulWidget {
  static const String routeName = '/group-details';
  final Group group;
  const GroupDetailsScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  bool isExpanded = false;
  final GroupsServices groupsServices = GroupsServices();

  Future<void> disableGroup() async {
    await groupsServices.disableGroup(groupId: widget.group.id!);
  }

  void openDeleteConfirmation(BuildContext context) async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: disableGroup,
              confirmText: 'eliminar',
              confirmColor: Colors.red,
              middleText: 'eliminar',
              endText: 'el grupo',
            ));
  }

  RichText listTileContent(String label, String value) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 18),
            text: "$label: ",
            children: [
          TextSpan(
              //text: widget.group.name.toUpperCase(),
              text: value.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.primaryColor,
                  fontSize: 20))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                GroupLogo(letter: widget.group.name[0].toUpperCase()),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    CustomButtonIcons(
                        onTap: () => fromGroupDetailsToManageGroup(
                            context, widget.group),
                        delete: false),
                    CustomButtonIcons(
                        //onTap: () {},
                        onTap: () => openDeleteConfirmation(context),
                        delete: true),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //title: Text("Nombre: Grupo ${widget.group.name.toUpperCase()}"),
            tileColor: Colors.grey.shade400,
            title: listTileContent("Nombre", widget.group.name),
            // title: RichText(
            //     text: TextSpan(
            //         style: const TextStyle(color: Colors.black, fontSize: 18),
            //         text: "Nombre: ",
            //         children: [
            //       TextSpan(
            //           text: widget.group.name.toUpperCase(),
            //           style: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: GlobalVariables.primaryColor,
            //               fontSize: 20))
            //     ]))
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // title: Text(
            //     // "Fecha de creación: ${datetimeToString(widget.group.dataEntry)}"),
            //     "Fecha de creación: ${dateFormatFromString(widget.group.dataEntry)}"),
            title: listTileContent(
                "Fecha de creación",
                formatDateWithTime(
                    dateFormatFromString(widget.group.dataEntry).toString())),
            // title: RichText(
            //     text: TextSpan(
            //         style: const TextStyle(color: Colors.black, fontSize: 18),
            //         text: "Fecha de creación: ",
            //         children: [
            //       TextSpan(
            //           text: widget.group.name.toUpperCase(),
            //           style: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: GlobalVariables.primaryColor,
            //               fontSize: 20))
            //     ])),
            tileColor: Colors.grey.shade400,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // title:
            //     Text("Nombres de Pagos: ${widget.group.paymentNames.length}"),
            title: listTileContent("Cantidad de nombres",
                widget.group.paymentNames.length.toString()),
            tileColor: Colors.grey.shade400,
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
          ),
          isExpanded
              ? Expanded(
                  child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: GlobalVariables.whiteColor,
                    child: Column(
                      children: widget.group.paymentNames
                          .map((name) => ListTile(
                                title: Text(name.name),
                              ))
                          .toList(),
                    ),
                  ),
                ))
              : const SizedBox()
        ],
      ),
    );
  }
}
