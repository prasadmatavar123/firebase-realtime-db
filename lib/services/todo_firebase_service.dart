import 'package:firebase_database/firebase_database.dart';

import '../models/todo_model.dart';

class TodoFirebaseService {
  final DatabaseReference _todosRef =
  FirebaseDatabase.instance.ref('todos');

  // CREATE
  Future<void> addTodo(TodoModel todo) async {
    final newTodoRef = _todosRef.push();

    await newTodoRef.set({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
    });
  }

  // READ
  Stream<List<TodoModel>> getTodos() {
    return _todosRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <TodoModel>[];
      }

      final Map<dynamic, dynamic> todoMap =
      data as Map<dynamic, dynamic>;

      return todoMap.entries.map((entry) {
        return TodoModel.fromMap(
          entry.key.toString(),
          Map<dynamic, dynamic>.from(entry.value),
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateTodo(TodoModel todo) async {
    await _todosRef.child(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
    });
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    await _todosRef.child(id).remove();
  }

  // UPDATE COMPLETION STATUS
  Future<void> updateTodoStatus(
      String id,
      bool isCompleted,
      ) async {
    await _todosRef.child(id).update({
      'isCompleted': isCompleted,
    });
  }
}