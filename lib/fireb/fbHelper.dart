import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future registerNumber(number, name) async {
  await Firebase.initializeApp();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(number)
      .set({"name": name, "status": "neg"});
  return;
}

// Future getAlertData() async {
//   QueryDocumentSnapshot a;
//   await Firebase.initializeApp();
//   Stream snapStream =
//       FirebaseFirestore.instance.collection('alertusers').snapshots();
//   snapStream.listen((event) {
//     (event.docs).forEach((doc) {
//       print("doc");
//       print(doc.data());
//     });
//   });
// }

Stream snapStream =
    FirebaseFirestore.instance.collection('alertusers').snapshots();
Stream userStream = FirebaseFirestore.instance.collection('users').snapshots();
