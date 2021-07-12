import 'package:flutter/material.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/widgets/todo_widget.dart';
import 'package:what_todo/helpers/database_helper.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
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
                            onSubmitted: (value) async {
                              if (value != '') {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Task _newTask = Task(
                                  title: value,
                                  description: '',
                                );
                                await _dbHelper.insertTask(_newTask);
                                print('Inserted new task');
                              }
                            },
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
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter description for the task...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                  TodoWidget(
                    text: 'Create your first task',
                    isDone: true,
                  ),
                  TodoWidget(
                    text: 'Create your first task as well',
                    isDone: true,
                  ),
                  TodoWidget(
                    text: 'Just another todo',
                    isDone: false,
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
