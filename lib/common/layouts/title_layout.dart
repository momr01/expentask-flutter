import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';

class TitleLayout extends StatelessWidget {
//  final bool isLoading;
  final Widget child;
  final String title;
//  final TextEditingController searchController;
//  final Function(String) onSearch;
//  final Future<void> Function() refreshData;
  final bool withBackBtn;
//  final String searchPlaceholder;
  final bool withFloatBtn;
  final FloatingActionButtonLocation floatBtnLocation;
  final Widget? floatBtn;

  const TitleLayout(
      {Key? key,
      // required this.isLoading,
      required this.child,
      required this.title,
      //   required this.searchController,
      //  required this.onSearch,
      //   required this.refreshData,
      this.withBackBtn = true,
      //  this.searchPlaceholder = "Buscar...",
      this.withFloatBtn = false,
      this.floatBtnLocation = FloatingActionButtonLocation.endDocked,
      this.floatBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        /*RefreshIndicator(
      onRefresh: refreshData,
      child:*/
        Scaffold(
      //  appBar: isMain ? null : customAppBar(context),
      appBar: customAppBar(context),
      drawer: withBackBtn ? null : const CustomDrawer(),
      floatingActionButtonLocation: floatBtnLocation,
      floatingActionButton: withFloatBtn ? floatBtn : null,
      body:
          /*ModalProgressHUD(
          color: GlobalVariables.greyBackgroundColor,
          opacity: 0.8,
          blur: 0.8,*/
          //inAsyncCall: isLoading,
          //  child:
          Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            MainTitle(title: title),
            const SizedBox(height: 10),
            // SearchTextField(
            //   placeholder: searchPlaceholder,
            //   searchController: searchController,
            //   onChange: onSearch,
            // ),
            // const SizedBox(height: 10),
            child
          ],
        ),
      ),
      //  ),
      // ),
    );
  }
}
