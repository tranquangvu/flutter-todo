import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:what_todo/screens/home_screen.dart';
import 'package:what_todo/screens/task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/task': (context) => TaskScreen(),
        });
  }
}
