import 'package:flutter/material.dart';
import 'package:nearby/constant.dart';
import 'package:nearby/fireb/fbHelper.dart';
import 'package:nearby/helpers/rangeModel.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Alerts')),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: buildInnerStreamBuilder(mediaQuery),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey,
              Colors.indigo,
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<dynamic> buildInnerStreamBuilder(mediaQuery) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data.docs;

          //Querydocumentsnapshot
          var documents = [];
          data.forEach((doc) {
            // print(doc.data());
            documents.add(doc.data());
          });
          if (documents.length != 0) {
            // getAlert(documents);
            return FutureBuilder(
              future: getAlert(documents),
              builder: (context, snapshot) {
                print("matches : ${snapshot.data}");

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length != 0) {
                    print('herre');
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return alertCard(
                            mediaQuery,
                            snapshot.data[index]['date'],
                            snapshot.data[index]['days'],
                            index + 1,
                          );
                        },
                      ),
                    );
                  }
                }

                return Center(child: cusTextNo('No Alerts!', FontWeight.bold));
              },
            );
          }
          return Center(child: cusTextNo('No Alerts!', FontWeight.bold));
        }
        return centerCircular();
      },
      stream: snapStream,
    );
  }

  Widget alertCard(mediaQuery, date, days, index) {
    return Container(
      height: mediaQuery.height * 0.3,
      width: mediaQuery.width * 0.7,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                '$index. Alert!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              cusText(
                  'A person you met on $date, $days days ago was tested positive for COVID.',
                  FontWeight.normal),
              SizedBox(
                height: 10,
              ),
              cusText(
                'You are advised to take COVID test in the nearest centre, as soon as possible.',
                FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cusText(content, fweight) {
    return Text(content,
        style: TextStyle(
          fontWeight: fweight,
          fontSize: 16,
        ));
  }

  Widget cusTextNo(content, fweight) {
    return Text(content,
        style: TextStyle(
          color: Colors.white,
          fontWeight: fweight,
          fontSize: 16,
        ));
  }
}
