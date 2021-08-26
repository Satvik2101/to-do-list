import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/to_do_item.dart';

import '../providers/items_list.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({
    Key? key,
    required this.currentList,
    this.title,
    this.description,
    this.dueDate,
    this.wasTimeSet,
    this.id,
  }) : super(key: key);
  final ItemsList currentList;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? id;
  final bool? wasTimeSet;
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask>
    with SingleTickerProviderStateMixin {
  bool _validate = false;
  late Color themeColor;
  bool _isChoosingDateTime = false;

  String? title;
  String? description;
  DateTime? dueDate;
  TimeOfDay? selectedTime;
  late bool wasTimeSet;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void initState() {
    title = widget.title;
    description = widget.description;
    dueDate = widget.dueDate;
    themeColor = widget.currentList.iconColor;
    if (dueDate != null) {
      _isChoosingDateTime = true;
    }
    wasTimeSet = widget.wasTimeSet ?? false;
    Future.delayed(Duration.zero).then((value) {
      if (title != null) {
        _titleController.text = title!;
        _titleController.selection =
            TextSelection.fromPosition(TextPosition(offset: title!.length));
      }
      if (description != null) {
        _descriptionController.text = description!;
        _descriptionController.selection = TextSelection.fromPosition(
            TextPosition(offset: description!.length));
      }
    });
    super.initState();
  }

  void _saveTask() {
    if (title == null) {
      setState(() {
        _validate = true;
      });

      return;
    }

    setState(() {
      _validate = false;
    });

    if (widget.id == null) {
      widget.currentList.addItem(
        ToDoItem(
          id: 'Task' + DateTime.now().toString(),
          title: title!,
          description: description,
          dueDate: dueDate,
          hasTimePassed: ValueNotifier(
            dueDate?.isBefore(DateTime.now()) ?? false,
          ),
          wasTimeSet: wasTimeSet,
        ),
      );

      Navigator.of(context).pop();
    } else {
      widget.currentList.updateItem(
        ToDoItem(
          id: widget.id!,
          title: title!,
          description: description,
          dueDate: dueDate,
          hasTimePassed: ValueNotifier(
            false,
          ),
          wasTimeSet: wasTimeSet,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        accentColor: themeColor,
        primaryColor: themeColor,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
            top: 25,
          ),
          height: MediaQuery.of(context).size.height *
                  (_isChoosingDateTime ? 0.6 : 0.5) +
              MediaQuery.of(context).viewInsets.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.id == null
                    ? 'Add New Task to ${widget.currentList.title}'
                    : 'Edit task $title',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: themeColor),
                  ),
                  errorText: _validate ? "Can't be empty" : null,
                ),
                onChanged: (value) {
                  title = value;
                },
                onSubmitted: (value) {
                  title = value;
                },
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: themeColor),
                  ),
                ),
                onChanged: (value) {
                  description = value;
                },
                onSubmitted: (value) {
                  description = value;
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Due Date',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isChoosingDateTime = !_isChoosingDateTime;
                      });
                    },
                    icon: Icon(
                      _isChoosingDateTime
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  )
                ],
              ),
              if (_isChoosingDateTime)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: (dueDate == null ||
                                  dueDate!.isBefore(DateTime.now()))
                              ? DateTime.now()
                              : dueDate!,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 100),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            if (selectedTime != null) {
                              DateTime newDatetime = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );
                              setState(() {
                                dueDate = newDatetime;
                              });
                            } else {
                              setState(() {
                                dueDate = value;
                              });
                            }
                          });
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Choose Date'),
                      style: TextButton.styleFrom(
                        primary: themeColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        dueDate = dueDate ?? DateTime.now();
                        selectedTime = await showTimePicker(
                          context: context,
                          initialTime: (dueDate == null ||
                                  dueDate!.isBefore(
                                    DateTime.now(),
                                  ))
                              ? TimeOfDay.now()
                              : TimeOfDay.fromDateTime(dueDate!),
                        );
                        if (selectedTime != null) {
                          wasTimeSet = true;
                          DateTime newDatetime = DateTime(
                            dueDate!.year,
                            dueDate!.month,
                            dueDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          setState(() {
                            dueDate = newDatetime;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: const Text('Choose Time'),
                      style: TextButton.styleFrom(
                        primary: themeColor,
                      ),
                    ),
                  ],
                ),
              if (dueDate != null)
                Container(
                  padding: const EdgeInsets.only(
                    right: 4,
                    left: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: themeColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('EEE, MMM d, yyyy h:mm a').format(dueDate!),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            dueDate = null;
                            wasTimeSet = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: themeColor,
                ),
                child: Text(widget.id == null ? 'Add Task' : 'Update Task'),
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
