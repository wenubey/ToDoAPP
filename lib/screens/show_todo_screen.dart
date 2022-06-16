import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_example/screens/add_todo_screen.dart';
import 'package:sqflite_example/screens/edit_todo_screen.dart';
import '../provider/todo_provider.dart';



class ShowTodoScreen extends StatelessWidget {
  const ShowTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final todoP = Provider.of<ToDoProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTodoScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                useSafeArea: true,
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: const Text('Delete All'),
                  content: const Text('Do you want to delete all of it ?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        await todoP.deleteAll();
                        Navigator.pop(context);
                      },
                      child: const Text('Yes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ToDoProvider>(context, listen: false).selectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ToDoProvider>(
              builder: (context, todoProvider, child) {
                return todoProvider.todoItem.isNotEmpty
                    ? ListView.builder(
                        itemCount: todoProvider.todoItem.length,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todoItem[index];
                          return Dismissible(
                            key: ValueKey(todo.id),
                            background: Container(
                              margin: EdgeInsets.all(width * 0.01),
                              padding: EdgeInsets.all(width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              alignment: Alignment.centerLeft,
                              height: height * 0.02,
                              width: width,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              padding: EdgeInsets.all(width * 0.03),
                              margin: EdgeInsets.all(width * 0.01),
                              width: width,
                              height: height * 0.02,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditTodoScreen(
                                      id: todo.id,
                                      title: todo.title,
                                      description: todo.description,
                                      date: todo.date,
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    scrollable: true,
                                    title: const Text('Delete'),
                                    content: const Text(
                                        'Do you want to delete it ?'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          todoProvider.deleteById(todo.id);
                                          todoProvider.deleteItemOnList(todo);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                style: ListTileStyle.drawer,
                                title: Text(todo.title),
                                subtitle: Text(todo.description),
                                trailing: Text(todo.date),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'List is empty',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 35.0,
                          ),
                        ),
                      );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
