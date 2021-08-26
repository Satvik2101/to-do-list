import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lists.dart';
import '../providers/items_list.dart';

class AddNewList extends StatefulWidget {
  const AddNewList({
    Key? key,
    this.isEditing = false,
    this.index,
  }) : super(key: key);

  final bool isEditing;
  final int? index;
  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  List<Color> colorsList = const [
    Colors.black,
    Colors.deepPurple,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.grey,
    Colors.amber,
    Colors.pink,
  ];
  List<IconData> iconsList = const [
    Icons.list,
    Icons.bookmark,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.library_books,
    Icons.music_note,
    Icons.card_giftcard,
    Icons.book,
    Icons.attach_money,
    Icons.sports_baseball,
    Icons.house,
    Icons.build,
    Icons.apartment,
    Icons.cake,
    Icons.flag,
    Icons.palette,
    Icons.pedal_bike,
    Icons.personal_video,
    Icons.pets,
    Icons.phone,
    Icons.flight,
    Icons.place,
    Icons.push_pin_outlined,
    Icons.science,
    Icons.search,
    Icons.notifications,
    Icons.icecream,
    Icons.storefront_rounded,
    Icons.child_care,
  ];

  late String title;
  late final Lists listsData;
  late Icon icon;
  late final List<ItemsList> lists;
  late Color color;
  var _controller = TextEditingController();

  bool _isInit = true;
  bool _validate = false;

  void _saveList() {
    if (title == '') {
      setState(() {
        _validate = true;
      });
      return;
    }
    setState(() {
      _validate = false;
    });

    if (!widget.isEditing) {
      listsData.addList(title, icon.icon!, color);
    } else {
      if (widget.index == null) {
        return;
      }
      listsData.updateList(widget.index!, title, icon.icon!, color);
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      listsData = Provider.of<Lists>(context, listen: false);
      lists = listsData.lists;
      icon = Icon(
        widget.index == null ? Icons.list : lists[widget.index!].iconData,
        size: 80,
        color: Colors.white,
      );
      color =
          widget.index == null ? Colors.blue : lists[widget.index!].iconColor;
      title = widget.index == null ? '' : lists[widget.index!].title;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = title;
    _controller.selection =
        TextSelection.fromPosition(TextPosition(offset: title.length));

    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(top: 20),
      height: MediaQuery.of(context).size.height * 0.87,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: icon,
            radius: 50,
            //maxRadius: 70,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _controller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter list title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
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
          const SizedBox(height: 30),
          SizedBox(
            height: 130,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: colorsList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 10,
                  maxCrossAxisExtent: 60,
                  crossAxisSpacing: 10),
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    color = colorsList[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: color == colorsList[index]
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  child: CircleAvatar(
                    backgroundColor: colorsList[index],
                  ),
                ),
              ),
              //child: const Icons.check),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: iconsList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 10,
                  maxCrossAxisExtent: 60,
                  crossAxisSpacing: 10),
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    icon = Icon(
                      iconsList[index],
                      color: Colors.white,
                      size: 60,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: icon.icon == iconsList[index]
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      iconsList[index],
                      color: Colors.white,
                      //size: 60,
                    ),
                  ),
                ),
              ),
              //child: const Icons.check),
            ),
          ),
          ElevatedButton(
            onPressed: _saveList,
            child: Text(widget.isEditing ? 'Update List' : 'Add New List'),
          ),
        ],
      ),
    );
  }
}
