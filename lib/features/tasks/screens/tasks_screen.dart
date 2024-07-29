import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/tasks/services/tasks_services.dart';
import 'package:payments_management/features/tasks/widgets/add_task_form.dart';
import 'package:payments_management/features/tasks/widgets/task_card_individual.dart';
import 'package:payments_management/models/task_code/task_code.dart';

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

  fetchAllTaskCodes() async {
    setState(() {
      _isLoading = true;
    });
    taskCodes = await tasksServices.fetchTaskCodes();
    setState(() {
      _foundTaskCodes = taskCodes!;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<TaskCode> results = [];
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
    });
  }

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
