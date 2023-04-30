import 'dart:developer';
import 'package:flutter/material.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../services/uuid_gen.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add Task.',
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
                    if (titleController.text.isEmpty) {
                      
                      // const snackBar = SnackBar(
                      //   content: Text('กรุณาใส่ title'),
                      //   duration: Duration(seconds: 1),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    } else {
                      UniqueIdGenerator generator = UniqueIdGenerator();
                      String uniqueId = generator.generateUniqueId();
                      var task = Task(
                          title: titleController.text,
                          description: descriptionController.text,
                          id: uniqueId,
                          date: DateTime.now().toString());
                      context.read<TasksBloc>().add(AddTask(task: task));
                      Navigator.pop(context);
                      log('Create Task ID = ${task.id} : ${task.title}');
                    }
                  },
                  child: const Text('Add'))
            ],
          )
        ],
      ),
    );
  }
}
