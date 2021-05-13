import 'package:flutter/material.dart';

import 'alert_screen.dart';

class BluetoothOffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('GuardMe'),
      ),
      // backgroundColor: Colors.blue,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              text('Bluetooth is OFF'),
              // SizedBox(height: mediaQuery * 0.2),
              iconContainer(mediaQuery),
              text('Turn on your Bluetooth to keep yourself monitored'),
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[900],
              Colors.indigo,
            ],
          ),
        ),
      ),
    );
  }

  Widget iconContainer(mQ) {
    return Center(
      child: Container(
        height: mQ * 0.15,
        width: mQ * 0.11,
        child: Icon(
          Icons.bluetooth,
          color: Colors.blue,
          size: 30,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget text(string) {
    return Center(
      child: Text(
        string,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
