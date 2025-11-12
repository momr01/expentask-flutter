// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/form_manage_name/services/form_manage_name_services.dart';
import 'package:payments_management/features/form_manage_name/widgets/category_section.dart';
import 'package:payments_management/features/form_manage_name/widgets/default_tasks_section.dart';
import 'package:payments_management/features/form_manage_name/widgets/name_section.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class FormManageNameScreen extends StatefulWidget {
  static const String routeName = '/form-manage-name';
  final PaymentName name;
  final List<Category> categories;
  final List<TaskCode> taskCodes;
  final TextEditingController searchController;

  const FormManageNameScreen(
      {Key? key,
      required this.name,
      required this.categories,
      required this.taskCodes,
      required this.searchController})
      : super(key: key);

  @override
  State<FormManageNameScreen> createState() => _FormManageNameScreenState();
}

class _FormManageNameScreenState extends State<FormManageNameScreen> {
  //List<Category>? categories;
  //List<TaskCode>? taskCodes;
  List<TaskCode> defaultTasks = [];
  List<TaskCode> selectedTasks = [];

  final NamesServices namesServices = NamesServices();
  final FormManageNameServices formManageNameServices =
      FormManageNameServices();
  final _manageNameFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  late String _categoryValue = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //fetchCategories();
    // fetchTaskCodes();
    _nameController.text = widget.name.id != null ? widget.name.name : "";

    setOtherValues();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  /* fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    categories = await namesServices.fetchCategories(context: context);
    setState(() {
      _categoryValue = widget.name.id != null
          ? widget.name.category.id!
          : categories == null
              ? "-Seleccione-"
              : categories![0].id!;

      checkingContentLoaded(categories, "una categoría");
    });
  }
*/
/*
  fetchTaskCodes() async {
    setState(() {
      _isLoading = true;
    });
    taskCodes = await formManageNameServices.fetchTaskCodes(context: context);
    setState(() {
      defaultTasks = taskCodes!;

      if (widget.name.id != null) {
        if (widget.name.defaultTasks != null) {
          if (widget.name.defaultTasks!.isNotEmpty) {
            for (var task in widget.name.defaultTasks!) {
              TaskCode item =
                  defaultTasks.firstWhere((element) => element.id == task);
              selectedTasks.add(item);
              defaultTasks.remove(item);
            }
          }
        }
      }

      checkingContentLoaded(taskCodes, "un código");
    });
  }
  */

  setOtherValues() {
    setState(() {
      _categoryValue = widget.name.id != null
          ? widget.name.category.id!
          : widget.categories[0].id!;
      // : widget.categories == null
      //     ? "-Seleccione-"
      //     : widget.categories![0].id!;

      //checkingContentLoaded(categories, "una categoría");
      defaultTasks = widget.taskCodes;

      if (widget.name.id != null) {
        if (widget.name.defaultTasks != null) {
          if (widget.name.defaultTasks!.isNotEmpty) {
            for (var task in widget.name.defaultTasks!) {
              // TaskCode item =
              TaskCode defaultTask =
                  TaskCode(name: "", user: "", number: 0, abbr: "");

              TaskCode item = defaultTasks.firstWhere(
                (element) => element.id == task,
                orElse: () => defaultTask,
              );

              if (item.id != null) {
                selectedTasks.add(item);
                defaultTasks.remove(item);
              }
            }
          }
        }
      }

      // checkingContentLoaded(taskCodes, "un código");
    });
  }

  // void checkingContentLoaded() {
  //   if (categories != null && taskCodes != null) {
  //     if (categories!.isNotEmpty && taskCodes!.isNotEmpty) {
  //       _isLoading = false;
  //     }
  //   } else {
  //     _isLoading = false;
  //     errorModal(
  //       context: context,
  //       description:
  //           "Debe crear al menos una categoría y un código, antes de registrar o editar un nombre.",
  //       onTap: () {
  //         Navigator.pushNamedAndRemoveUntil(
  //             context, BottomBar.routeName, arguments: 1, (route) => false);
  //       },
  //     );
  //   }
  // }

  void checkingContentLoaded(var elements, String textType) {
    if (elements != null) {
      if (elements!.isNotEmpty) {
        _isLoading = false;
      }
    } else {
      _isLoading = false;
      errorModal(
        context: context,
        description:
            "Debe crear al menos $textType, antes de registrar o editar un nombre.",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 1, (route) => false);
        },
      );
    }
  }

  void addDefaultTaskToSelectedGroup(TaskCode task) {
    setState(() {
      selectedTasks.add(task);
      defaultTasks.remove(task);
    });
  }

  void deleteTaskFromSelectedGroup(TaskCode task) {
    setState(() {
      defaultTasks.add(task);
      selectedTasks.remove(task);
    });
  }

  Future<void> editName() async {
    List<String> ids = [];

    for (var item in selectedTasks) {
      ids.add(item.id!);
    }

    await formManageNameServices.editName(
        context: context,
        id: widget.name.id!,
        name: _nameController.text,
        category: _categoryValue,
        defaultTasks: ids,
        searchController: widget.searchController);
  }

  Future<void> addName() async {
    List<String> ids = [];

    for (var item in selectedTasks) {
      ids.add(item.id!);
    }

    await formManageNameServices.addName(
        context: context,
        name: _nameController.text,
        categoryId: _categoryValue,
        defaultTasks: ids);
  }

  void openModalConfirmation() async {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ModalConfirmation(
        onTap: widget.name.id != null ? editName : addName,
        confirmText: widget.name.id != null ? 'editar' : 'registrar',
        confirmColor: widget.name.id != null
            ? GlobalVariables.completeButtonColor!
            : Colors.blue,
        middleText: widget.name.id != null ? 'editar' : 'registrar',
        endText: 'el nombre del pago',
      ),
    );
  }

  void onChangeCategory(String? value) {
    setState(() {
      _categoryValue = value!;
    });
  }

  void validateForm() {
    if (_manageNameFormKey.currentState!.validate()) {
      openModalConfirmation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              MainTitle(
                  title: widget.name.id != null
                      ? 'Editar nombre de pago'
                      : 'Registrar nombre de pago'),
              const SizedBox(
                height: 30,
              ),
              Flexible(
                  child: ListView(children: [
                Form(
                  key: _manageNameFormKey,
                  child: Column(
                    children: [
                      NameSection(
                        nameController: _nameController,
                      ),
                      CategorySection(
                        categoryValue: _categoryValue,
                        onChange: (value) => onChangeCategory(value),
                        categories: widget.categories,
                      ),
                      DefaultTasksSection(
                          defaultTasks: defaultTasks,
                          selectedTasks: selectedTasks,
                          onPressed: (task) =>
                              addDefaultTaskToSelectedGroup(task),
                          onDeleted: (task) =>
                              deleteTaskFromSelectedGroup(task)),
                      selectedTasks.isNotEmpty
                          ? CustomButton(
                              text: widget.name.id != null
                                  ? 'EDITAR'
                                  : 'REGISTRAR',
                              color: GlobalVariables.completeButtonColor,
                              onTap: validateForm,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: 'CANCELAR',
                          color: GlobalVariables.greyBackgroundColor,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
