import 'package:nearby/helpers/rangeModel.dart';
import 'package:flutter/material.dart';
import 'package:nearby/helpers/dBHelper.dart';
import 'package:nearby/models/prefsModel.dart';
import 'package:nearby_connections/nearby_connections.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mobile = '';
  String summa = '';
  final Strategy strategy = Strategy.P2P_STAR;
  List<Map<String, String>> persons = [];
  bool status = false;
  @override
  void initState() {
    initializeMobile();
    initalizePersons();
    super.initState();
  }

  initializeMobile() async {
    mobile = await getKeyValue('mobile');
    print(mobile);
  }

  initalizePersons() async {
    DatabaseHelper().getRangesMapList().then((value) {
      // print(value);
      value.forEach((element) {
        Map<String, String> map = {};
        print('${element['mobile']}');
        map['mobile'] = '${element['mobile']}';
        map['date'] = '${element['date']}';
        persons.add(map);
        print(persons);
      });
    });
    setState(() {
      summa = 'as';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              status ? offButton() : onButton(),
              FutureBuilder(
                future: DatabaseHelper().getRangesMapList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.length == 0) {
                      return Container(
                        height: 200,
                        child: Center(
                          child: Text('No data yet'),
                        ),
                      );
                    }
                    if (snapshot.data != null || snapshot.data.length != 0) {
                      return Container(
                        height: 200,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(persons[index]['mobile']),
                              subtitle: Text(persons[index]['date']),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  int days = (Range.differenceInDays(
                                      persons[index]['date'], '2021-05-20'));

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("$days days"),
                                  ));
                                },
                                child: Text('Difference (may 20)'),
                              ),
                            );
                          },
                          itemCount: persons.length,
                        ),
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget onButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ),
        onPressed: () async {
          try {
            bool a = await Nearby().startAdvertising(
              mobile,
              strategy,
              onConnectionInitiated: (String id, ConnectionInfo info) {
                // Called whenever a discoverer requests connection
              },
              onConnectionResult: (String id, Status status) {
                // Called when connection is accepted/rejected
              },
              onDisconnected: (String id) {
                // Callled whenever a discoverer disconnects from advertiser
              },
              serviceId: "com.example.nearby", // uniquely identifies your app
            );
          } catch (exception) {
            print('d $exception');
            // platform exceptions like unable to start bluetooth or insufficient permissions
          }
          try {
            bool a = await Nearby().startDiscovery(
              mobile,
              strategy,
              onEndpointFound:
                  (String id, String userName, String serviceId) async {
                await DatabaseHelper().insertBasedOnCondition(userName);
                DatabaseHelper().getRangesMapList().then((value) {
                  print(value);
                  value.forEach((element) {
                    Map<String, String> map = {};
                    print('${element['mobile']}');
                    map['mobile'] = '${element['mobile']}';
                    map['date'] = '${element['date']}';
                    persons.add(map);
                  });
                });
                setState(() {
                  summa = 'as';
                });
                // print(id);
                // print(userName);
                // print(serviceId);
              },
              onEndpointLost: (String id) {
                //called when an advertiser is lost (only if we weren't connected to it )
              },
              serviceId: "com.example.nearby", // uniquely identifies your app
            );
          } catch (e) {
            print('d $e');
            // platform exceptions like unable to start bluetooth or insufficient permissions
          }
          setState(() {
            status = !status;
          });
        },
        child: Text('on'));
  }

  Widget offButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        onPressed: () async {
          await Nearby().stopAdvertising();
          await Nearby().stopDiscovery();
          setState(() {
            status = !status;
          });
        },
        child: Text('off'));
  }
}
