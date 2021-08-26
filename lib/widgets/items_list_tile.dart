import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/tasks_screen.dart';
import 'add_new_list.dart';
import '../providers/items_list.dart';

class ItemsListTile extends StatelessWidget {
  const ItemsListTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;
  final Icon ic = const Icon(Icons.edit);

  @override
  Widget build(BuildContext context) {
    final itemsList = Provider.of<ItemsList>(context);
    return Container(
      color: Colors.white,
      //padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      child: Material(
        child: InkWell(
          //splashColor: Colors.grey,
          onTap: () {
            Navigator.of(context)
                .pushNamed(TasksScreen.routeName, arguments: index);
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 12,
              ),
              CircleAvatar(
                radius: 27,
                backgroundColor: itemsList.iconColor,
                child: Icon(
                  itemsList.iconData,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            itemsList.title,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Expanded(child: SizedBox()),
                          ClipOval(
                            child: Material(
                              child: InkWell(
                                splashColor: Colors.grey,
                                child: SizedBox(
                                  width: 66,
                                  height: 66,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (ctx) {
                                      return AddNewList(
                                        isEditing: true,
                                        index: index,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
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
