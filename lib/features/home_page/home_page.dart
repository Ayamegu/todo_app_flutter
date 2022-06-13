import 'package:flutter/material.dart';
import '../../enum/task_state.dart';
import '../../model/todo.dart';
import 'home_bloc.dart';
import 'widget/todo_list.dart';

class HomePage extends StatelessWidget {
  final _bloc = HomeBloc();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _bloc.fetchAllTodo(); // acquire the values to be displayed in the list

    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: StreamBuilder<List<Todo>>(
        initialData: _bloc.listDataSource.value,
        stream: _bloc.listDataSource.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            return TodoList(
              snapshot,
              _bloc.updateTaskState,
              _bloc.deleteTask,
              _bloc.editTask,
            );
          } else if (snapshot.hasError) {
            return Text("An error has occurred. Message:${snapshot.error}");
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.addTask(Todo(999, 'new task', TaskState.todo));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}