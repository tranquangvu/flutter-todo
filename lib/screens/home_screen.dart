import 'package:flutter/material.dart';
import 'package:what_todo/helpers/database_helper.dart';
import 'package:what_todo/widgets/task_card_widget.dart';
import 'package:what_todo/models/task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 32.0,
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Task>>(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.data!.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 32.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 64.0,
                                  height: 64.0,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/empty_icon.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  'There are no remaining tasks',
                                  style: TextStyle(
                                    color: Color(0xFF86829D),
                                    height: 1.5,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ]
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/task',
                                  arguments: {
                                    'task': snapshot.data![index],
                                  },
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: TaskCardWidget(
                                title: snapshot.data![index].title,
                                description: snapshot.data![index].description,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/task',
                      arguments: {
                        'task': null,
                      },
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF7349FE),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/add_icon.png',
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
