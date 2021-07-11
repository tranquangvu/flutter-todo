import 'package:flutter/material.dart';
import 'package:what_todo/widgets/task_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Color(0xFFF6F6F6),
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
                    child: ListView(
                      children: [
                        TaskCardWidget(
                          title: 'Get Started',
                          description:
                              'Hello! Welcome to Todo app, this is a default task that you can edit or delete to start using the app.',
                        ),
                        TaskCardWidget(),
                        TaskCardWidget(),
                        TaskCardWidget(),
                        TaskCardWidget(),
                        TaskCardWidget(),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: 6.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/task');
                  },
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7349FE),
                          Color(0xFF643FDB),
                        ],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
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
