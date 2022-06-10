import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app_flutter/Enum/task_state.dart';
import 'package:todo_app_flutter/Model/todo.dart';
import 'package:todo_app_flutter/Repository/todo_repository.dart';

class HomeBloc {
  // Todo fetch from repository.
  // Value retrieval is done asynchronously.
  final _repository = TodoRepository();
  final _todoFetcher = PublishSubject<List<Todo>>();

  // MARK: Output
  BehaviorSubject<List<Todo>> listDataSource =
      BehaviorSubject<List<Todo>>.seeded([]);

  // MARK: Input
  final _updateCheckSubject = PublishSubject<int>();
  final _addTaskSubject = PublishSubject<Todo>();

  void fetchAllTodo() async {
    List<Todo> todoList = await _repository.fetchAllProvider();
    _todoFetcher.sink.add(todoList);
  }

  void updateTaskState(int index) {
    _updateCheckSubject.sink.add(index);
  }

  void addTask(Todo todo) {
    _addTaskSubject.sink.add(todo);
  }

  HomeBloc() {
    // data binding
    _bind();
  }

  void _bind() {
    // fetch
    _todoFetcher.stream.listen((todoList) {
      listDataSource.sink.add(todoList);
    });

    // update
    _updateCheckSubject.stream.listen((index) {
      List<Todo> currentTodoList = listDataSource.value;
      final isDone = currentTodoList[index].state == TaskState.done;
      currentTodoList[index].state = isDone ? TaskState.todo : TaskState.done;
      listDataSource.sink.add(currentTodoList);
    });

    // add
    _addTaskSubject.stream.listen((todo) {
      List<Todo> currentTodoList = listDataSource.value;
      currentTodoList.add(todo);
      listDataSource.sink.add(currentTodoList);
    });
  }

  dispose() {
    _todoFetcher.close();
    listDataSource.close();
  }
}
