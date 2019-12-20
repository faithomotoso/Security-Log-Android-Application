import 'package:flutter/cupertino.dart';

import '../utils/db_util.dart';
import 'package:scoped_model/scoped_model.dart';

class Visitor {
  static Visitor visitor;

//  Visitor._createInstance();

  int id;
  String visitor_name;
  String person_visiting;
  String phoneNo;
  String _time_in;
  String _time_out;
  String date;

  set time_in(String time) {
    _time_in = time;
  }

  set time_out(String time) {
    _time_out = time;
  }

  String get time_in => _time_in;

  String get time_out => _time_out;

  String get time_in_clock {
    debugPrint("Visitor.dart time in: $time_in");
    List<String> timeSplit = time_in.split(' ');
    String time = "${timeSplit[1]} ${timeSplit[2]}";
    return time;
  }

  String get time_out_clock {
    List<String> timeSplit = time_out.split(' ');
    String time = "${timeSplit[1]} ${timeSplit[2]}";
    return time;
  }

//  @override
//  String toString() {
//    return "${visitor.visitor_name}";
//  }

  // convert database entry to a Visitor object
  Visitor.fromMapObject(Map<String, dynamic> db_result) {
    this.id = db_result['id'];
    this.visitor_name = db_result['visitor_name'];
    this.person_visiting = db_result['person_visiting'];
    this.phoneNo = db_result['phone_number'];
    this.time_in = db_result['time_in'];
    this.time_out = db_result['time_out'];
    this.date = db_result["date"];
  }

  // convert Visitor object to map for database transaction
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'visitor_name': visitor_name,
      'person_visiting': person_visiting,
      'phone_number': phoneNo,
      'time_in': time_in,
      'time_out': time_out,
      'id': id != null ? id : null,
      "date" : date
    };
    return map;
  }

  Visitor({id, visitor_name, person_visiting, phoneNo, time_in, time_out});

}
