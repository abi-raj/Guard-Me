import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nearby/helpers/dBHelper.dart';
import 'package:nearby/models/prefsModel.dart';
import 'package:nearby/screens/alert_screen.dart';
import 'package:nearby_connections/nearby_connections.dart';

class HomeMainScreen extends StatefulWidget {
  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  static const String netOn =
      'You are being monitered\nClick top icon to see alerts.';
  static const String netOff =
      'Turn on Internet to sync with alerts!.\nYou are being monitered';
  int todayCount = 0;
  @override
  void initState() {
    initToday();
    initDiscoverMode();
    super.initState();
  }

  @override
  void dispose() {
    disposeDiscoverMode();
    super.dispose();
  }

  initToday() async {
    int n = await DatabaseHelper().getTodayCounts();
    setState(() {
      todayCount = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GuardMe'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => AlertsScreen()));
                },
                icon: Icon(Icons.notification_important_rounded)),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<Object>(
          initialData: 'none',
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data != ConnectivityResult.none) {
              return Center(
                // child: alertCard(mediaQuery, '', ''),
                child: iconContainer(
                  Icons.check_sharp,
                  Colors.green,
                  netOn,
                  todayCount,
                ),
                // child:
              );
            } else {
              return Center(
                child: iconContainer(
                    Icons.warning, Colors.yellow[800], netOff, todayCount),
              );
            }
          },
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

  Widget iconContainer(IconData icon, ic_color, txt, todayCount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        text('Contacts Met Today : $todayCount'),
        Container(
          height: 200,
          width: 100,
          child: Icon(
            icon,
            color: ic_color,
            size: 40,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        text(txt)
      ],
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

  initDiscoverMode() async {
    String mobile = await getKeyValue('mobile');
    bool a;
    try {
      a = await Nearby().startAdvertising(
        mobile,
        Strategy.P2P_STAR,
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
    print('d-advertise : $a');

    bool b;
    try {
      b = await Nearby().startDiscovery(
        mobile,
        Strategy.P2P_STAR,
        onEndpointFound: (String id, String userName, String serviceId) async {
          print(userName);
          await DatabaseHelper().insertBasedOnCondition(userName);
          await initToday();
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
    print('d-discover: $b');
  }

  disposeDiscoverMode() async {
    await Nearby().stopAdvertising();
    await Nearby().stopDiscovery();
  }
}
