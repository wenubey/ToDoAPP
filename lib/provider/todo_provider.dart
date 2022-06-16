import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sqflite_example/db_helper/db_helper.dart';
import 'package:uuid/uuid.dart';
import '../model/todo_model.dart';

class ToDoProvider extends ChangeNotifier {
  List<ToDoModel> _todoItem = [];

  UnmodifiableListView<ToDoModel> get todoItem =>
      UnmodifiableListView(_todoItem);

  Future<void> selectData() async {
    final dataList = await DBHelper.selectAll(DBHelper.todo);

    _todoItem = dataList
        .map(
          (item) => ToDoModel(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            date: item['date'],
          ),
        )
        .toList();
    notifyListeners();
  }


  Future deleteItemOnList(Object value) async {
    _todoItem.remove(value);
  }

  Future insertData(
    String title,
    String description,
    String date,
  ) async {
    final newTodo = ToDoModel(
      id: const Uuid().v1(),
      title: title,
      description: description,
      date: date,
    );
    _todoItem.add(newTodo);

    DBHelper.insert(
      DBHelper.todo,
      {
        'id': newTodo.id,
        'title': newTodo.title,
        'description': newTodo.description,
        'date': newTodo.date,
      },
    );
    notifyListeners();
  }

  Future updateTitle({required String id, required String title}) async {
    DBHelper.update(
      DBHelper.todo,
      'title',
      title,
      id,
    );
    notifyListeners();
  }

  Future updateDescription(
      {required String id, required String description}) async {
    DBHelper.update(
      DBHelper.todo,
      'description',
      description,
      id,
    );
    notifyListeners();
  }

  Future updateDate({required String id, required String date}) async {
    DBHelper.update(
      DBHelper.todo,
      'date',
      date,
      id,
    );
    notifyListeners();
  }

  Future deleteById(id) async {
    DBHelper.deleteById(
      DBHelper.todo,
      'id',
      id,
    );
    notifyListeners();
  }

  Future deleteAll() async {
    DBHelper.deleteTable(DBHelper.todo);
    _todoItem.clear();
    notifyListeners();
  }
}
