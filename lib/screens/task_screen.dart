import 'package:flutter/material.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/widgets/todo_widget.dart';
import 'package:what_todo/helpers/database_helper.dart';

class TaskScreen extends StatefulWidget {
  static const routeName = '/task';

  final Task? task;

  TaskScreen({
    this.task,
  });

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = '';
  String _taskDescription = '';
  bool _contentVisible = false;

  FocusNode _titleFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  FocusNode _todoFocus = FocusNode();

  @override
  void initState() {
    if (widget.task != null) {
      _taskId = widget.task!.id;
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;
      _contentVisible = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                'assets/images/back_arrow_icon.png',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value == '') {
                                return;
                              }
                              if (_taskId == 0) {
                                Task _newTask = Task(
                                  id: 0,
                                  title: value,
                                  description: '',
                                );
                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _taskTitle = value;
                                  _contentVisible = true;
                                });
                              } else {
                                await _dbHelper.updateTask(_taskId, {
                                  'title': value,
                                });
                              }
                              _descriptionFocus.requestFocus();
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value == '') {
                            return;
                          }
                          if (_taskId != 0) {
                            await _dbHelper.updateTask(_taskId, {
                              'description': value,
                            });
                            setState(() {
                              _taskDescription = value;
                            });
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: 'Enter description for the task...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder<List<Todo>>(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await _dbHelper
                                      .updateTodo(snapshot.data![index].id, {
                                    'isDone': !snapshot.data![index].isDone,
                                  });
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: Color(0xFF86829D),
                                width: 1.5,
                              ),
                            ),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = '',
                              onSubmitted: (value) async {
                                if (value == '') {
                                  return;
                                }
                                if (_taskId != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                    id: 0,
                                    title: value,
                                    isDone: false,
                                    taskId: _taskId,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  _todoFocus.requestFocus();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter todo item...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Image(
                        image: AssetImage(
                          'assets/images/delete_icon.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
