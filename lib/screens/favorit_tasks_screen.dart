import 'package:flutter/material.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../widgets/tasks_list.dart';

class FavoritTasksScreen extends StatelessWidget {
  const FavoritTasksScreen({Key? key}) : super(key: key);
  static const id = 'tasks_screen';
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.favouriteTasks;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                label: Text(
                  '${state.favouriteTasks.length} Tasks',
                ),
              ),
            ),
            TasksList(tasksList: tasksList)
          ],
        );
      },
    );
  }
}
