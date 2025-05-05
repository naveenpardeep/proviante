import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isComplete;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'isComplete': isComplete,
  };

  static Todo fromMap(Map map) => Todo(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    createdAt: DateTime.parse(map['createdAt']),
    isComplete: map['isComplete'],
  );
}

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    loadData();
  }

  final _todosBox = Hive.box("todos");

  Future<void> createInitialData() async {
    state = [
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Proviante Task 1",
        description: "This is a sample description",
        createdAt: DateTime.now(),
      ),
      Todo(
        id: "${DateTime.now().millisecondsSinceEpoch}2",
        title: "Proviante Task 2",
        description: "Another sample description",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isComplete: true,
      ),
    ];
    _updateData();
  }

  void loadData() {
    final todoMaps = _todosBox.get("TODOLIST") as List?;
    if (todoMaps == null) {
      createInitialData();
      return;
    }
    state = todoMaps.map((e) => Todo.fromMap(e)).toList();
  }

  void _updateData() {
    _todosBox.put("TODOLIST", state.map((e) => e.toMap()).toList());
  }

  void addTodo(String title, String description) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    state = [newTodo, ...state];
    _updateData();
  }

  void editTodo(String id, String title, String description) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: id,
            title: title,
            description: description,
            createdAt: todo.createdAt,
            isComplete: todo.isComplete,
          )
        else
          todo,
    ];
    _updateData();
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isComplete: !todo.isComplete,
          )
        else
          todo,
    ];
    _updateData();
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _updateData();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
