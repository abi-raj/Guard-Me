import 'package:nearby/helpers/dBHelper.dart';

class Range {
  int id;
  String mobile;
  String date;

  Range(this.mobile, this.date);

  //Object to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['date'] = date;
    map['mobile'] = mobile;
    return map;
  }

  Range.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.date = map['date'];
    this.mobile = map['mobile'];
  }

  static int differenceInDays(dateAdded, currentDate) {
    // var date = (DateTime.now().toString().split(' ')[0]);
    DateTime dateTimeAddedAt = DateTime.parse(dateAdded);
    DateTime cd = DateTime.parse(currentDate);
    final differenceInDays = cd.difference(dateTimeAddedAt).inDays;
    return differenceInDays;
  }
}

//For testing lookout on this method
Future<List<Map<String, String>>> getAlert(data) async {
  List<Map<String, String>> result = [];
  print(data);
  for (var val in data) {
    bool res = await DatabaseHelper().getRangeExists(val['mobile']);
    //temporary date
    print("local : $res");
    //var date = val['date']; firebase one
    if (res) {
      String date = await DatabaseHelper().getRangeDate(val['mobile']);
      String currentDate = (DateTime.now().toString().split(' ')[0]);
      int days = Range.differenceInDays(date, currentDate);
      print("days diff : $days");
      if (days <= 14) {
        Map<String, String> map = {};
        map['date'] = '$date';
        map['days'] = '$days';
        print("map :$map");
        result.add(map);
      }
    }
  }
  print(result);
  return result;
}
