import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lists.dart';
import '../widgets/items_list_tile.dart';
import '../widgets/add_new_list.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your lists'),
      ),
      body: FutureBuilder(
        future: Provider.of<Lists>(context, listen: false).fetchAndSetLists(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Consumer<Lists>(builder: (context, listsData, _) {
                    final lists = listsData.lists;
                    return lists.length == 0
                        ? const Center(
                            child: Text('Add New Lists!'),
                          )
                        : ListView.builder(
                            itemCount: lists.length,
                            itemBuilder: (ctx, index) => Dismissible(
                              key: ValueKey(lists[index].id),
                              onDismissed: (_) {
                                //lists.removeAt(index);
                                listsData.removeListAtIndex(index);
                              },
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: const EdgeInsets.only(right: 15),
                                color: Colors.red,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.delete),
                                ),
                              ),
                              child: ChangeNotifierProvider.value(
                                value: lists[index],
                                child: ItemsListTile(
                                  index: index,
                                ),
                              ),
                            ),
                            //itemExtent: 200,
                          );
                  }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return const AddNewList();
            },
          );
        },
      ),
    );
  }
}
