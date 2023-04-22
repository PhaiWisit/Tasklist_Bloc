import 'dart:developer';

import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../services/guid_gen.dart';

class EditTaskScreen extends StatelessWidget {
  final Task oldTask;
  const EditTaskScreen({
    Key? key,
    required this.oldTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: oldTask.title);
    TextEditingController descriptionController =
        TextEditingController(text: oldTask.description);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Edit Task.',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            autofocus: true,
            controller: titleController,
            decoration: const InputDecoration(
              label: Text('Title'),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            autofocus: true,
            minLines: 3,
            maxLines: 5,
            controller: descriptionController,
            decoration: const InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('cancel')),
              ElevatedButton(
                  onPressed: () {
                    var editedTask = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        id: oldTask.id,
                        isDone: false,
                        isFavourite: oldTask.isFavourite,
                        date: DateTime.now().toString());
                    context
                        .read<TasksBloc>()
                        .add(EditTask(oldTask: oldTask, newTask: editedTask));
                    Navigator.pop(context);
                    log('Create Task ID = ${editedTask.id} : ${editedTask.title}');
                  },
                  child: const Text('Save'))
            ],
          )
        ],
      ),
    );
  }
}
