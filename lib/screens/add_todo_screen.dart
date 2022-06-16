import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo_provider.dart';
import '../widgets/myTextfield.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Column(
        children: [
          MyTextField(
            controller: _titleController,
            hint: 'Title',
          ),
          MyTextField(
            controller: _descriptionController,
            hint: 'Description',
          ),

          MyTextField(
            controller: _dateController,
            hint: 'Date',
          ),
          ElevatedButton(
            onPressed: () async {
              todoProvider.insertData(
                _titleController.text,
                _descriptionController.text,
                _dateController.text,
              );
              _titleController.clear();
              _descriptionController.clear();
              _dateController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
