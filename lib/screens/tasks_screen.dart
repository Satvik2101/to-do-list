import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_list.dart';
import '../widgets/add_new_task.dart';

import '../widgets/tasks_list.dart';
import '../providers/lists.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  static const routeName = '\tasks-screen';
  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)?.settings.arguments as int;
    final currentList =
        Provider.of<Lists>(context, listen: false).findByIndex(index);
    return ChangeNotifierProvider.value(
      value: currentList,
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentList.title),
          backgroundColor: currentList.iconColor,
        ),
        body: FutureBuilder(
          future: currentList.fetchAndSetTasks().then((value) async {
            if (value == false) {
              await Future.delayed(const Duration(milliseconds: 1000));
            }
          }),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<ItemsList>(
                      builder: (ctx, currentList, _) =>
                          currentList.items.length == 0
                              ? const Center(
                                  child: Text('Add New Tasks!'),
                                )
                              : ChangeNotifierProvider.value(
                                  value: currentList,
                                  child: const TasksList(),
                                ),
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: currentList.iconColor,
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => AddNewTask(currentList: currentList),
              isScrollControlled: true,
            );
          },
        ),
      ),
    );
  }
}
