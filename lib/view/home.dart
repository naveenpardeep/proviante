import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proviante/components/dailog.dart';
import 'package:proviante/components/todo_tile.dart';
import 'package:proviante/provider/todo_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

    final sortedTodos = [...todos]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    void showAddEditDialog({Todo? todo}) {
      showDialog(
        context: context,
        builder: (context) {
          return TodoDialog(
            initialTitle: todo?.title ?? '',
            initialDesc: todo?.description ?? '',
            onSave: (title, description) {
              if (todo == null) {
                todoNotifier.addTodo(title, description);
              } else {
                todoNotifier.editTodo(todo.id, title, description);
              }
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
            dialogTitle: todo == null ? 'Add New Task' : 'Edit Task',
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 93, 78, 121),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 93, 78, 121),
        title: const Text(
          "Заметки",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: sortedTodos.length,
        itemBuilder: (context, index) {
          final todo = sortedTodos[index];
          return TodoTile(
            key: ValueKey(todo.id),
            todo: todo,
            onToggle: () => todoNotifier.toggleTodo(todo.id),
            onEdit: () => showAddEditDialog(todo: todo),
            onDelete: () => todoNotifier.deleteTodo(todo.id),
          );
        },
      ),
    );
  }
}
