import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/tasks/services/tasks_services.dart';
import 'package:payments_management/features/tasks/widgets/add_task_form.dart';
import 'package:payments_management/features/tasks/widgets/task_card_individual.dart';
import 'package:payments_management/models/task_code/task_code.dart';
import 'package:payments_management/common/utils/fetch_data.dart';

class TasksScreen extends StatefulWidget {
  static const String routeName = '/tasks';
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskCode>? taskCodes = [];
  List<TaskCode> _foundTaskCodes = [];
  final TextEditingController _searchController = TextEditingController();
  TasksServices tasksServices = TasksServices();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllTaskCodes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchAllTaskCodes() {
    /* setState(() {
      _isLoading = true;
    });
    taskCodes = await tasksServices.fetchOwnTaskCodes();
    setState(() {
      _foundTaskCodes = taskCodes!;
      _isLoading = false;
    });*/
    fetchData<TaskCode>(
        context: context,
        fetchFunction: tasksServices.fetchOwnTaskCodes,
        onSuccess: (items) => setState(() {
              taskCodes = items;
              _foundTaskCodes = items;
            }),
        onStart: () => setState(() => _isLoading = true),
        onComplete: () => setState(() => _isLoading = false));
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundTaskCodes = runFilter<TaskCode>(
          keyword,
          taskCodes!,
          (code) =>
              code.name.toLowerCase().contains(keyword.toLowerCase()) ||
              code.abbr.toLowerCase().contains(keyword.toLowerCase()) ||
              code.number
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()));

      /* for (var element in filterOptions) {
        if (element.type == "all") {
          element.state = true;
        } else {
          element.state = false;
        }
      }*/
    });

    /* List<TaskCode> results = [];
    if (enteredKeyword.isEmpty) {
      results = taskCodes!;
    } else {
      results = taskCodes!
          .where((code) =>
              code.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              code.abbr.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              code.number
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTaskCodes = results;
    });*/
  }

  Future<void> _refreshData() async {
    fetchAllTaskCodes();
    _searchController.clear();
  }
/*
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: TitleSearchLayout(
        //isMain: true,
        isLoading: _isLoading,
        title: 'Tareas',
        searchController: _searchController,
        onSearch: _runFilter,
        searchPlaceholder: "Buscar tarea...",
        child: Expanded(
          child: ListView(
            children: [
              SizedBox(
                height: 250,
                child: ConditionalListView(
                  items: _foundTaskCodes,
                  foundItems: _foundTaskCodes,
                  loader: const Loader(),
                  emptyMessage: "¡No existen tareas para mostrar!",
                  itemBuilder: (context, code) => TaskCardIndividual(
                    code: code,
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  verticalPosition: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const AddTaskForm()
            ],
          ),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const CustomDrawer(),
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              const MainTitle(title: 'Tareas'),
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
              Expanded(
                child: ListView(
                  children: [
                    taskCodes == null
                        ? const Loader()
                        : taskCodes!.isEmpty
                            ? const Text('No existen tareas para mostrar!')
                            : _foundTaskCodes.isEmpty
                                ? const Text(
                                    'No existen resultados a su búsqueda!',
                                    style: TextStyle(fontSize: 16),
                                  )
                                : SizedBox(
                                    height: 250,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              width: 20,
                                            ),
                                        itemCount: _foundTaskCodes.length,
                                        itemBuilder: (context, index) {
                                          return TaskCardIndividual(
                                            code: _foundTaskCodes[index],
                                          );
                                        }),
                                  ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AddTaskForm()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
