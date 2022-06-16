import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_example/widgets/myTextfield.dart';

import '../provider/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.date})
      : super(key: key);
  final String id;
  final String title;
  final String description;
  final String date;

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _dateController.text = widget.date;

    super.initState();
  }

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
        title: const Text('Edit Todo'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              onPressed: () {
                todoProvider.updateTitle(
                  id: widget.id,
                  title: _titleController.text,
                );
                todoProvider.updateDescription(
                  id: widget.id,
                  description: _descriptionController.text,
                );
                todoProvider.updateDate(
                  id: widget.id,
                  date: _dateController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
