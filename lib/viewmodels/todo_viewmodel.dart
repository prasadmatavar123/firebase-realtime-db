import 'dart:async';

import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../services/todo_firebase_service.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoFirebaseService _service = TodoFirebaseService();

  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StreamSubscription<List<TodoModel>>? _todoSubscription;

  TodoViewModel() {
    _listenToTodos();
  }

  // READ
  void _listenToTodos() {
    _todoSubscription = _service.getTodos().listen((todoList) {
      _todos = todoList;
      notifyListeners();
    });
  }

  // CREATE
  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final todo = TodoModel(
        id: '',
        title: title,
        description: description,
        isCompleted: false,
      );

      await _service.addTodo(todo);
    } catch (e) {
      debugPrint('Add Todo Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _service.updateTodo(todo);
    } catch (e) {
      debugPrint('Update Todo Error: $e');
    }
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    try {
      await _service.deleteTodo(id);
    } catch (e) {
      debugPrint('Delete Todo Error: $e');
    }
  }

  // COMPLETE / UNCOMPLETE
  Future<void> toggleTodo(TodoModel todo) async {
    try {
      await _service.updateTodoStatus(
        todo.id,
        !todo.isCompleted,
      );
    } catch (e) {
      debugPrint('Toggle Todo Error: $e');
    }
  }

  @override
  void dispose() {
    _todoSubscription?.cancel();
    super.dispose();
  }
}