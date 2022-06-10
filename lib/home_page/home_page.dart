import 'package:flutter/material.dart';
import 'package:todo_app_flutter/Enum/task_state.dart';
import 'package:todo_app_flutter/Model/todo.dart';
import 'package:todo_app_flutter/home_page/home_bloc.dart';

class HomePage extends StatelessWidget {
  final _bloc = HomeBloc();

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
            return _todoList(snapshot);
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

  // TodoList
  Widget _todoList(AsyncSnapshot<List<Todo>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Checkbox(
            value: snapshot.data![index].state == TaskState.done,
            onChanged: (value) {
              _bloc.updateTaskState(index);
            },
          ),
          title: Text(
            snapshot.data![index].title,
            style: snapshot.data![index].state == TaskState.done
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  )
                : null,
          ),
        );
      },
    );
  }
}
