import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/home/widgets/search_text_field.dart';

class TitleSearchLayout extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String title;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final Future<void> Function() refreshData;
  final bool isMain;
  final String searchPlaceholder;
  final bool withFloatBtn;
  final FloatingActionButtonLocation floatBtnLocation;
  final Widget? floatBtn;

  const TitleSearchLayout(
      {Key? key,
      required this.isLoading,
      required this.child,
      required this.title,
      required this.searchController,
      required this.onSearch,
      required this.refreshData,
      this.isMain = false,
      this.searchPlaceholder = "Buscar...",
      this.withFloatBtn = false,
      this.floatBtnLocation = FloatingActionButtonLocation.endDocked,
      this.floatBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Scaffold(
        appBar: isMain ? null : customAppBar(context),
        drawer: isMain ? null : const CustomDrawer(),
        floatingActionButtonLocation: floatBtnLocation,
        floatingActionButton: withFloatBtn ? floatBtn : null,
        body: ModalProgressHUD(
          color: GlobalVariables.greyBackgroundColor,
          opacity: 0.8,
          blur: 0.8,
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              children: [
                MainTitle(title: title),
                const SizedBox(height: 10),
                /* SearchTextField(
                  placeholder: searchPlaceholder,
                  searchController: searchController,
                  onChange: onSearch,
                ),*/
                AnimatedSearchTextField(
                  placeholder: searchPlaceholder,
                  searchController: searchController,
                  onChange: onSearch,
                ),
                const SizedBox(height: 10),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String value) onChange;
  final String placeholder;

  const AnimatedSearchTextField({
    super.key,
    required this.searchController,
    required this.onChange,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: searchController,
      builder: (context, _) {
        return TextFormField(
          controller: searchController,
          onChanged: onChange,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, size: 28),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: searchController.text.isNotEmpty
                  ? IconButton(
                      key: const ValueKey('clear'),
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () {
                        searchController.clear();
                        onChange("");
                      },
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
            labelText: placeholder,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            filled: true,
            fillColor: GlobalVariables.greyBackgroundColor,
            isDense: true,
          ),
          maxLines: 1,
        );
      },
    );
  }
}
