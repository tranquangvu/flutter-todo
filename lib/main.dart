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
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) {
        final arguments = settings.arguments as Map<String, dynamic>;

        switch (settings.name) {
          case (TaskScreen.routeName):
            {
              // correct screen.
              return MaterialPageRoute(
                builder: (context) {
                  return TaskScreen(
                    task: arguments['task'],
                  );
                },
              );
            }
          default:
            {
              return null;
            }
        }
      },
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
