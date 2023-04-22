import 'package:flutter/material.dart';

import '../models/task.dart';

class PopupMenu extends StatelessWidget {
  final Task task;
  final VoidCallback cancelOrDeleteCalleback;
  final VoidCallback likeOrDislikeCallback;
  final VoidCallback editTaskCallback;

  const PopupMenu({
    Key? key,
    required this.cancelOrDeleteCalleback,
    required this.likeOrDislikeCallback,
    required this.editTaskCallback,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: task.isDeleted == false
          ? ((context) => [
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: editTaskCallback,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  onTap: editTaskCallback,
                ),
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: null,
                    icon: task.isFavourite == false
                        ? const Icon(Icons.bookmark_add_outlined)
                        : const Icon(Icons.bookmark_remove),
                    label: task.isFavourite == false
                        ? const Text('Add to \nBookmarks')
                        : const Text('Remove from \nBookmarks'),
                  ),
                  onTap: likeOrDislikeCallback,
                ),
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                  onTap: cancelOrDeleteCalleback,
                ),
              ])
          : (context) => [
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.restore_outlined),
                    label: const Text('Restore'),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete Forever'),
                  ),
                  onTap: cancelOrDeleteCalleback,
                ),
              ],
    );
  }
}
