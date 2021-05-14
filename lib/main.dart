import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nearby/models/prefsModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby/screens/home_screen.dart';
import 'package:nearby/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[800],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      title: 'Guard-Me',
      home: Decider(),
    );
  }
}

class Decider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getKeyValue('mobile'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            print(snapshot.data);
            return HomeScreen();
          }
          return RegisterScreen();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
