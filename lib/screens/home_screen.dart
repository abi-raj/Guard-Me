import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nearby/screens/main_info_screen.dart';

import 'bluetooth_off_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        initialData: BluetoothState.unknown,
        stream: FlutterBlue.instance.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return HomeMainScreen();
          }
          return BluetoothOffScreen();
        });
  }
}
