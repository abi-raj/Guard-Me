import 'package:flutter/material.dart';
import 'package:nearby/fireb/fbHelper.dart';
import 'package:nearby/models/prefsModel.dart';

import 'package:nearby/screens/home_screen.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../constant.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController;
  TextEditingController numberController;
  bool onTapped = false;
  @override
  void initState() {
    askPerm();
    nameController = new TextEditingController();
    numberController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: centerCard()),
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

  Widget centerCard() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Wrap(
              runSpacing: 10.0,
              children: [
                centerText(),
                textField(nameController, TextInputType.name, 'Your Name'),
                textField(
                    numberController, TextInputType.number, 'Mobile Number'),
                onTapped ? centerCircular() : button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(controller, type, hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLength: type == TextInputType.number ? 10 : null,
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }

  Widget button() {
    return Center(
      child: SizedBox(
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          onPressed: () async {
            if (nameController.text.length != 0 &&
                numberController.text.length == 10) {
              setState(() {
                onTapped = true;
              });
              await authAndNavigate();
              setState(() {
                onTapped = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("Please Enter Valid values"),
              ));
            }
          },
          child: Text(
            'GO',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget centerText() {
    return Center(
      child: Text(
        'REGISTER',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  authAndNavigate() async {
    registerNumber(numberController.text, nameController.text).then((value) {
      setKeyValue('name', nameController.text);
      setKeyValue('mobile', numberController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error.toString()),
      ));
    });
  }

  askPerm() async {
    bool a = await Nearby().checkLocationPermission();
    if (!a) {
      await Nearby().askLocationPermission();
    }
// asks for permission only if its not given
// returns true/false if the location permission is granted on/off resp.
  }
}
