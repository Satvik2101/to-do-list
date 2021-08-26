import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './add_new_task.dart';
import '../models/to_do_item.dart';
import '../providers/items_list.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("Building again");
    final itemsList = Provider.of<ItemsList>(context);
    //print(itemsList.length);
    final themeColor = itemsList.iconColor;

    return Theme(
      data: ThemeData(
        accentColor: themeColor,
      ),
      child: ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (ctx, index) => TaskItem(
          index,
          themeColor,
          key: ValueKey(
            itemsList.items[index].id,
          ),
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem(this.index, this.themeColor, {Key? key}) : super(key: key);
  final int index;
  final Color themeColor;
  @override
  _TaskItemState createState() => _TaskItemState();
}

String getDisplayDuration(Duration duration) {
  if (duration.isNegative) {
    return 'LATE';
  }
  if (duration.inDays > 30) {
    double value = (duration.inDays.toDouble() / 30);
    return value.toStringAsPrecision(2) + (value == 1 ? ' month' : ' months');
  }

  if (duration.inDays != 0) {
    double value = duration.inDays +
        (duration.inHours - duration.inDays * 24).toDouble() / 24;
    return value.toStringAsPrecision(2) + ((value == 1) ? ' day' : ' days');
  } else if (duration.inHours != 0) {
    double value = duration.inHours +
        (duration.inMinutes - duration.inHours * 60).toDouble() / 60;
    return value.toStringAsPrecision(2) + ((value == 1) ? ' hour' : ' hours');
  } else if (duration.inMinutes != 0) {
    double value = duration.inMinutes.toDouble() +
        (duration.inSeconds - duration.inMinutes * 60).toDouble() / 60;
    return value.toStringAsPrecision(2) +
        ((value == 1) ? ' minute' : ' minutes');
  } else if (duration.inSeconds != 0) {
    return duration.inSeconds.toString() +
        ((duration.inSeconds == 1) ? ' second' : ' seconds');
  } else
    return 'LATE';
}

class _TaskItemState extends State<TaskItem> {
  bool _isInit = true;
  late ToDoItem task;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      task = Provider.of<ItemsList>(context).getItemByIndex(widget.index);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _shouldRemove = false;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !_shouldRemove
          ? ValueListenableBuilder(
              valueListenable: task.hasTimePassed,
              builder: (ctx, bool hasTimePassed, _) {
                var color = hasTimePassed ? Colors.white : Colors.black;

                return Container(
                  decoration: BoxDecoration(
                    color: hasTimePassed ? Colors.red : Colors.white,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    //tileColor: tileColor,
                    title: Text(
                      task.title,
                      style: TextStyle(color: color),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        !_isChecked
                            ? Icons.radio_button_off
                            : Icons.radio_button_checked,
                        color: hasTimePassed ? Colors.white : widget.themeColor,
                      ),
                      onPressed: () async {
                        setState(() {
                          _isChecked = true;
                        });
                        await Future.delayed(
                          const Duration(milliseconds: 200),
                        );
                        setState(() {
                          _shouldRemove = !_shouldRemove;
                        });
                        await Future.delayed(
                          const Duration(milliseconds: 400),
                        );
                        Provider.of<ItemsList>(context, listen: false)
                            .removeItem(task.id);
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.description != null) const SizedBox(height: 5),
                        if (task.description != null)
                          Text(
                            task.description!,
                            style: TextStyle(
                              color: hasTimePassed ? Colors.white : Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (task.dueDate != null) const SizedBox(height: 10),
                        if (task.dueDate != null)
                          Text(
                            DateFormat(
                                    'EEE, MMM d, yyyy ${task.wasTimeSet ? 'h:mm a' : ''}')
                                .format(task.dueDate!),
                            style: TextStyle(
                              color: hasTimePassed
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                          ),
                      ],
                    ),
                    trailing: task.timeLeft != null
                        ? ValueListenableBuilder(
                            valueListenable: task.timeLeft!,
                            builder: (ctx, Duration timeLeftValue, _) => Text(
                              getDisplayDuration(timeLeftValue),
                              style: TextStyle(
                                color: color,
                              ),
                              softWrap: true,
                            ),
                          )
                        : null,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AddNewTask(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          dueDate: task.dueDate,
                          wasTimeSet: task.wasTimeSet,
                          currentList:
                              Provider.of<ItemsList>(context, listen: false),
                        ),
                      ).then((value) {
                        setState(() {
                          _isInit = true;
                        });
                      });
                    },
                  ),
                );
              },
            )
          : const SizedBox(),
    );
  }
}
