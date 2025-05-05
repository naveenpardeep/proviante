// components/todo_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proviante/provider/todo_provider.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: todo.isComplete,
                      onChanged: (_) => onToggle(),
                    ),
                    Expanded(
                      child: Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration:
                              todo.isComplete
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              onTap: onEdit,
                              child: const Text('Edit'),
                            ),
                            PopupMenuItem(
                              onTap: onDelete,
                              child: const Text('Delete'),
                            ),
                          ],
                    ),
                  ],
                ),
                if (todo.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, top: 8),
                    child: Text(
                      todo.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        decoration:
                            todo.isComplete
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 48.0, top: 8),
                  child: Text(
                    'Created: ${dateFormat.format(todo.createdAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
