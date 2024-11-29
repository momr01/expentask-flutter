import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/groups/services/groups_services.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/group_grid_view.dart';
import 'package:payments_management/features/groups/widgets/group_main_card.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/name/payment_name.dart';

// List<Group> groups = [
//   Group(
//       name: 'Pagos Mensuales',
//       dataEntry: DateTime.now(),
//       isActive: true,
//       paymentNames: [
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true))
//       ]),
//   Group(
//       name: 'Pagos Semestrales',
//       dataEntry: DateTime.now(),
//       isActive: true,
//       paymentNames: [
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true))
//       ]),
//   Group(
//       name: 'Pagos Anuales',
//       dataEntry: DateTime.now(),
//       isActive: true,
//       paymentNames: [
//         PaymentName(
//             name: 'Seguro Tres Provincias',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro Rivadavia',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true)),
//         PaymentName(
//             name: 'Seguro de Vida',
//             isActive: true,
//             category: Category(name: 'Seguros', isActive: true))
//       ]),
//   Group(
//     name: 'Pagos Especiales',
//     dataEntry: DateTime.now(),
//     isActive: true,
//     paymentNames: [
//       PaymentName(
//           name: 'Seguro Tres Provincias',
//           isActive: true,
//           category: Category(name: 'Seguros', isActive: true)),
//       PaymentName(
//           name: 'Seguro Rivadavia',
//           isActive: true,
//           category: Category(name: 'Seguros', isActive: true)),
//       PaymentName(
//           name: 'Seguro de Vida',
//           isActive: true,
//           category: Category(name: 'Seguros', isActive: true))
//     ],
//   )
// ];

class GroupsScreen extends StatefulWidget {
  static const String routeName = '/groups';
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  // List? groups = [];
  //List groups = [];
  /*List _foundGroups = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < 30; i++) {
    //   groups.add('value');
    //   _foundGroups.add('value');
    // }
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = groups!;
    } else {
      results = groups!;
      //   results = taskCodes!
      //       .where((code) =>
      //           code.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
      //           code.abbr.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
      //           code.number
      //               .toString()
      //               .toLowerCase()
      //               .contains(enteredKeyword.toLowerCase()))
      //       .toList();
    }

    setState(() {
      _foundGroups = results;
    });
  }*/

  List<Group>? groups;
  List<Group> _foundGroups = [];
  final GroupsServices groupsServices = GroupsServices();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchActiveGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchActiveGroups() {
    fetchData<Group>(
      context: context,
      fetchFunction: groupsServices.fetchActiveGroups,
      onStart: () => setState(() => _isLoading = true),
      onSuccess: (items) => setState(() {
        groups = items;
        _foundGroups = items;
      }),
      onComplete: () => setState(() => _isLoading = false),
    );
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundGroups = runFilter<Group>(
        keyword,
        groups!,
        (group) => group.name.toLowerCase().contains(keyword.toLowerCase()),
      );
    });
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.orange.shade300,
          foregroundColor: GlobalVariables.primaryColor,
          onPressed: () {},
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                children: [
                  const MainTitle(title: 'Grupos'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      filled: true,
                      fillColor: GlobalVariables.greyBackgroundColor,
                      isDense: true,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                //children: _foundGroups
                children: groups
                    .map(
                      (group) => GestureDetector(
                        onTap: () => fromGroupsToGroupDetails(context, group),
                        child: GroupMainCard(
                          group: group,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
        isLoading: _isLoading,
        title: 'Grupos',
        searchController: _searchController,
        onSearch: _runFilter,
        searchPlaceholder: "Buscar grupo...",
        /* child: ConditionalListView(
        items: groups,
        foundItems: _foundGroups,
        loader: const Loader(),
        emptyMessage: "¡No existen grupos para mostrar!",
        // itemBuilder: (context, payment) => PaymentCard(payment: payment),
        itemBuilder: (context, group) => GestureDetector(
          onTap: () => fromGroupsToGroupDetails(context, group),
          child: GroupMainCard(
            group: group,
          ),
        ),
        separatorBuilder: (context, _) => const Divider(),
      ),*/
        /* child: Expanded(
        child: GridView.count(
          primary: false,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          //children: _foundGroups
          children: _foundGroups
              .map(
                (group) => GestureDetector(
                  onTap: () => fromGroupsToGroupDetails(context, group),
                  child: GroupMainCard(
                    group: group,
                  ),
                ),
              )
              .toList(),
        ),
      ),*/
        child: GroupGridView(
          groups: groups,
          foundGroups: _foundGroups,
          loader: const Loader(),
          emptyMessage: "¡No existen grupos para mostrar!",
        ));
  }
}
