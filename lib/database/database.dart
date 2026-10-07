import 'package:todo/database/todo.dart';
import 'package:hive_ce_flutter/adapters.dart';

class HiveService {
  static const String boxName = 'task';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Box get box => Hive.box(boxName);

  Future<void> addTask(Todo todo) async {
    box.add({'title': todo.title,'details' : todo.details, 'isComplete': todo.isComplete});
  }

  List<Todo> getTasks() {
    List<Todo> tasks = [];
    for (int i = 0; i < box.length; i++) {
      tasks.add(
        Todo(
          title: box.getAt(i)['title'],
          details: box.getAt(i)['details'],
          isComplete: box.getAt(i)['isComplete'],
        ),
      );
    }
    return tasks;
  }

  Future<void> deleteTask(int index) async {
    await box.deleteAt(index);
  }

  Future<void> updateTask(int index, Todo todo) async {
    await box.putAt(index, {
      'title': todo.title,
      'details' : todo.details,
      'isComplete': todo.isComplete,
    });
  }


}
