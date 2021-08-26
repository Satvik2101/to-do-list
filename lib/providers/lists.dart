import 'package:flutter/material.dart';
import 'items_list.dart';
import '../helpers/DBHelper.dart';

class Lists extends ChangeNotifier {
  List<ItemsList> _lists = [];

  ItemsList findByIndex(int index) {
    return _lists[index];
  }

  Map<IconData, String> iconDataToString = {
    Icons.list: 'list',
    Icons.bookmark: 'bookmark',
    Icons.shopping_cart: 'shopping_cart',
    Icons.restaurant: 'restaurant',
    Icons.library_books: 'library_books',
    Icons.music_note: 'music_note',
    Icons.card_giftcard: 'card_giftcard',
    Icons.book: 'book',
    Icons.attach_money: 'attach_money',
    Icons.sports_baseball: 'sports_baseball',
    Icons.house: 'house',
    Icons.build: 'build',
    Icons.apartment: 'apartment',
    Icons.cake: 'cake',
    Icons.flag: 'flag',
    Icons.palette: 'palette',
    Icons.pedal_bike: 'pedal_bike',
    Icons.personal_video: 'personal_video',
    Icons.pets: 'pets',
    Icons.phone: 'phone',
    Icons.flight: 'flight',
    Icons.place: 'place',
    Icons.push_pin_outlined: 'push_pin_outlined',
    Icons.science: 'science',
    Icons.search: 'search',
    Icons.notifications: 'notifications',
    Icons.icecream: 'icecream',
    Icons.storefront_rounded: 'storefront_rounded',
    Icons.child_care: 'child_care',
  };
  Map<String, IconData> stringToIconData = {
    'list': Icons.list,
    'bookmark': Icons.bookmark,
    'shopping_cart': Icons.shopping_cart,
    'restaurant': Icons.restaurant,
    'library_books': Icons.library_books,
    'music_note': Icons.music_note,
    'card_giftcard': Icons.card_giftcard,
    'book': Icons.book,
    'attach_money': Icons.attach_money,
    'sports_baseball': Icons.sports_baseball,
    'house': Icons.house,
    'build': Icons.build,
    'apartment': Icons.apartment,
    'cake': Icons.cake,
    'flag': Icons.flag,
    'palette': Icons.palette,
    'pedal_bike': Icons.pedal_bike,
    'personal_video': Icons.personal_video,
    'pets': Icons.pets,
    'phone': Icons.phone,
    'flight': Icons.flight,
    'place': Icons.place,
    'push_pin_outlined': Icons.push_pin_outlined,
    'science': Icons.science,
    'search': Icons.search,
    'notifications': Icons.notifications,
    'icecream': Icons.icecream,
    'storefront_rounded': Icons.storefront_rounded,
    'child_care': Icons.child_care,
  };

  Future<void> fetchAndSetLists() async {
    final listsData = await DBHelper.getLists();
    List<ItemsList> tempLists = [];

    listsData.forEach(
      (listData) {
        List<String> colorRGBO = ((listData['colorRGBO'] as String).split(','));
        Color iconColor = Color.fromRGBO(
          int.parse(colorRGBO[0]),
          int.parse(colorRGBO[1]),
          int.parse(colorRGBO[2]),
          double.parse(
            colorRGBO[3],
          ),
        );
        ItemsList list = ItemsList(
          id: listData['id'],
          title: listData['title'],
          iconColor: iconColor,
          iconData: stringToIconData[listData['iconName']] ?? Icons.list,
        );
        tempLists.add(list);
      },
    );
    _lists = tempLists;

    // _lists.forEach((itemList) async {
    //   await itemList.fetchAndSetTasks();
    // });
    notifyListeners();
  }

  void addList(String title, IconData iconData, Color color) {
    final id = DateTime.now().toIso8601String();
    _lists.add(ItemsList(
      iconColor: color,
      iconData: iconData,
      id: id,
      title: title,
    ));
    notifyListeners();
    DBHelper.insertNewList({
      'id': id,
      'title': title,
      'colorRGBO': '${color.red},${color.green},${color.blue},${color.opacity}',
      'iconName': iconDataToString[iconData] ?? '',
    });
  }

  void removeListAtIndex(int index) {
    String idToBeDeleted = _lists[index].id;
    _lists.removeAt(index);
    DBHelper.deleteList(idToBeDeleted);
    notifyListeners();
  }

  void updateList(int index, String title, IconData iconData, Color color) {
    _lists[index].iconColor = color;
    _lists[index].iconData = iconData;
    _lists[index].title = title;
    notifyListeners();
    DBHelper.insertNewList({
      'id': _lists[index].id,
      'title': title,
      'colorRGBO': '${color.red},${color.green},${color.blue},${color.opacity}',
      'iconName': iconDataToString[iconData] ?? '',
    });
  }

  List<ItemsList> get lists {
    return [..._lists];
  }

  void removeById(String id) {
    _lists.removeWhere((list) => list.id == id);
    DBHelper.deleteList(id);
    notifyListeners();
  }
}
