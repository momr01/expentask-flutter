import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/home/widgets/search_text_field.dart';

/*class FloatBtnClass {
  final bool withFloatBtn;
  final bool loadFloatBtn;
  final VoidCallback? onTapFloatBtn;
  final FloatingActionButtonLocation? floatBtnLocation;

  FloatBtnClass(
      {required this.withFloatBtn,
      required this.loadFloatBtn,
      this.onTapFloatBtn,
      this.floatBtnLocation});
}*/

class TitleSearchLayout extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String title;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final bool isMain;
  final String searchPlaceholder;
  final bool withFloatBtn;
  final bool loadFloatBtn;
  final VoidCallback? onTapFloatBtn;
  final FloatingActionButtonLocation floatBtnLocation;
  // final FloatBtnClass floatBtn;

  const TitleSearchLayout(
      {Key? key,
      required this.isLoading,
      required this.child,
      required this.title,
      required this.searchController,
      required this.onSearch,
      this.isMain = false,
      this.searchPlaceholder = "Buscar...",
      this.withFloatBtn = false,
      this.loadFloatBtn = false,
      this.onTapFloatBtn,
      this.floatBtnLocation = FloatingActionButtonLocation.endDocked
      //required this.floatBtn,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMain ? null : customAppBar(context),
      drawer: isMain ? null : const CustomDrawer(),
      floatingActionButtonLocation: floatBtnLocation,
      //floatingActionButtonLocation:
      //   floatBtn.floatBtnLocation ?? FloatingActionButtonLocation.endDocked,
      // floatingActionButton: floatBtn.withFloatBtn
      floatingActionButton: withFloatBtn
          ? SizedBox(
              height: 80,
              width: 80,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: GlobalVariables.historicalPending,
                foregroundColor: Colors.white,
                // onPressed: floatBtn.onTapFloatBtn ?? () {},
                // child: floatBtn.loadFloatBtn
                onPressed: onTapFloatBtn ?? () {},
                child: loadFloatBtn
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.add,
                        size: 40,
                      ),
              ),
            )
          : null,
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              MainTitle(title: title),
              const SizedBox(height: 20),
              SearchTextField(
                placeholder: searchPlaceholder,
                searchController: searchController,
                onChange: onSearch,
              ),
              const SizedBox(height: 20),
              child, // Parte dinámica
            ],
          ),
        ),
      ),
    );
  }
}
