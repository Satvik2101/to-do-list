import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/tasks_screen.dart';
import 'providers/lists.dart';
import 'screens/lists_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Key? key;
  const MyApp({this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Lists(),
      builder: (ctx, lists) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const ListsScreen(),
        routes: {
          TasksScreen.routeName: (ctx) => const TasksScreen(),
        },
      ),
    );
  }
}
