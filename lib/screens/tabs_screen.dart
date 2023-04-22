import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/completed_tasks_screen.dart';
import 'package:flutter_tasks_app/screens/favorit_tasks_screen.dart';
import 'package:flutter_tasks_app/screens/my_drawer.dart';
import 'package:flutter_tasks_app/screens/pending_tasks_screen.dart';

import 'add_task_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const PendingTasksScreen(), 'title': 'Pending Tasks'},
    {'pageName': const CompletedTasksScreen(), 'title': 'Completed Tasks'},
    {'pageName': const FavoritTasksScreen(), 'title': 'Favourit Tasks'},
  ];

  var _selectedPage = 0;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddTaskScreen(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageDetails[_selectedPage]['title']),
        actions: [
          IconButton(
            onPressed: () => _addTask(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _pageDetails[_selectedPage]['pageName'],
      floatingActionButton: _selectedPage == 0
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Pending Tasks',
            icon: Icon(Icons.incomplete_circle_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Completed Tasks',
            icon: Icon(Icons.done),
          ),
          BottomNavigationBarItem(
            label: 'Favorit Tasks',
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}
