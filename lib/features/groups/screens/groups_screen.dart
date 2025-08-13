import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/float_btn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/features/groups/services/groups_services.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/group_grid_view.dart';
import 'package:payments_management/models/group/group.dart';

class GroupsScreen extends StatefulWidget {
  static const String routeName = '/groups';
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
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
      // context: context,
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

  void navigateToAddNewGroup() {
    fromGroupDetailsToManageGroup(context,
        Group(name: "", dataEntry: "", isActive: false, paymentNames: []));
  }

  Future<void> _refreshData() async {
    fetchActiveGroups();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
        refreshData: _refreshData,
        isLoading: _isLoading,
        title: 'Grupos',
        searchController: _searchController,
        onSearch: _runFilter,
        searchPlaceholder: "Buscar grupo...",
        withFloatBtn: true,
        floatBtnLocation: FloatingActionButtonLocation.centerDocked,
        floatBtn: FloatBtn(
          loadFloatBtn: false,
          onTapFloatBtn: navigateToAddNewGroup,
        ),
        child: GroupGridView(
          groups: groups,
          foundGroups: _foundGroups,
          loader: const Loader(),
          emptyMessage: "¡No existen grupos para mostrar!",
        ));
  }
}
