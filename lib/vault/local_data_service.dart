import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo_model.dart';
import '../models/note_model.dart';

class LocalDataService {
  static const String _todoBoxName = "todoBox";
  static const String _noteBoxName = "noteBox";
  
  final Box<TodoModel> todoBox = Hive.box<TodoModel>(_todoBoxName);
  final Box<NoteModel> noteBox = Hive.box<NoteModel>(_noteBoxName);

  // --- Task Methods ---
  Future<void> addTask(TodoModel todo) async {
    await todoBox.put(todo.id, todo);
  }

  Future<void> updateTask(TodoModel todo) async {
    await todo.save();
  }

  Future<void> deleteTask(TodoModel todo) async {
    await todo.delete();
  }

  ValueListenable<Box<TodoModel>> listenToTasks() {
    return todoBox.listenable();
  }

  // --- Note Methods ---
  Future<void> addNote(NoteModel note) async {
    await noteBox.add(note);
  }

  Future<void> updateNote(NoteModel note) async {
    await note.save();
  }

  Future<void> deleteNote(NoteModel note) async {
    await note.delete();
  }

  ValueListenable<Box<NoteModel>> listenToNotes() {
    return noteBox.listenable();
  }
}
