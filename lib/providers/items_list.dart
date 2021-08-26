import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/to_do_item.dart';
import '../helpers/DBHelper.dart';

class ItemsList extends ChangeNotifier {
  final String id;
  String title;
  List<ToDoItem> _items = [];
  IconData iconData;
  Color iconColor;

  ItemsList({
    required this.id,
    required this.title,
    required this.iconData,
    required this.iconColor,
  });
  int get length {
    return _items.length;
  }

  bool hasBeenFetched = false;
  List<ToDoItem> get items => [..._items];

  int get itemsDueToday {
    return _items
        .where((item) => item.dueDate?.day == DateTime.now().day)
        .length;
  }

  ToDoItem getItemByIndex(int index) => _items[index];

  Future<bool> fetchAndSetTasks() async {
    if (hasBeenFetched) {
      return true;
    }
    hasBeenFetched = true;
    final tasksData = await DBHelper.getListTasks(id);
    List<ToDoItem> tempList = [];
    if (tasksData.isEmpty) {
      return true;
    }
    tasksData.forEach((taskData) {
      ToDoItem task = ToDoItem(
        id: taskData['id'],
        wasTimeSet: taskData['wasTimeSet'] == 1 ? true : false,
        title: taskData['title'],
        description: taskData['description'],
        dueDate: taskData['dueDate'] == null
            ? null
            : DateTime.parse(taskData['dueDate']),
        hasTimePassed:
            ValueNotifier(taskData['hasTimePassed'] == 1 ? true : false),
      );
      tempList.add(task);
    });

    _items = tempList
      ..sort((item1, item2) {
        return item1.id.compareTo(item2.id);
      });
    notifyListeners();
    return false;
  }

  void addItem(ToDoItem item) {
    _items.add(item);

    notifyListeners();
    DBHelper.insertTaskInList(id, {
      'id': item.id,
      'title': item.title,
      'description': item.description,
      'dueDate': item.dueDate?.toIso8601String(),
      'hasTimePassed': item.hasTimePassed.value ? 1 : 0,
      'wasTimeSet': item.wasTimeSet ? 1 : 0,
    });
  }

  void updateItem(ToDoItem item) {
    int indexToBeUpdated =
        _items.indexWhere((element) => element.id == item.id);
    _items[indexToBeUpdated] = item;

    notifyListeners();
    DBHelper.insertTaskInList(id, {
      'id': item.id,
      'title': item.title,
      'description': item.description,
      'dueDate': item.dueDate?.toIso8601String(),
      'hasTimePassed': item.hasTimePassed.value ? 1 : 0,
      'wasTimeSet': item.wasTimeSet ? 1 : 0,
    });
  }

  void removeItem(String taskId) {
    _items.removeWhere((item) => item.id == taskId);
    DBHelper.deleteTaskFromList(id, taskId);
    notifyListeners();
  }
}
