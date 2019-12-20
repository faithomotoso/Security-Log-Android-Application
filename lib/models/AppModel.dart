import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:security_logs/models/Visitor.dart';
import 'package:security_logs/utils/db_util.dart';

class AppModel extends Model{
  final DbUtil _dbUtil = DbUtil();
  List<Visitor> visitorsList;
  List<Visitor> visitorsListDate;

  static AppModel _appModel;
  AppModel._createInstance();
  factory AppModel(){
    if (_appModel == null){
      _appModel = AppModel._createInstance();
    }
    return _appModel;
  }

  Future<List<Visitor>> getVisitorsList() async{
    visitorsList = await _dbUtil.getVisitorList();
    return visitorsList;
  }

  void getVisitorsListDate({String date}) async {
    await getVisitorsList();
    if (date == null){
      // on first run
      print("Date is null");
      date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }

    visitorsListDate = visitorsList.where((v) => v.date == date).toList();
    print(date);
    print("AppModel.dart visitors list date: ${visitorsListDate}");
    notifyListeners();
//    return visitorsListDate;
  }

  Future<int> _addVisitor(Visitor visitor) async {
    int result = await _dbUtil.addVisitor(visitor);
    getVisitorsListDate();
    return result;
  }

  Future<int> _updateVisitor(Visitor visitor) async {
    int result = await _dbUtil.updateVisitor(visitor);
    return result;
  }

  Future<int> _deleteVisitor(Visitor visitor) async {
    int result = await _dbUtil.deleteVisitor(visitor);
    return result;
  }

  Future<int> visitorCheckIn(Visitor visitor) async {
    // date
//    DateFormat dateFormat = DateFormat('y-MMMM-d').add_jm();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm aa");
    String date = dateFormat.format(DateTime.now());

    List<String> date_b = date.split(" ");
    String time = "${date_b[1]} ${date_b[2]}";

    visitor.date = date_b[0];

    visitor.time_in = time;

    visitor.time_out = ''; // non-null field

    notifyListeners();
    return await _addVisitor(visitor);
  }

  Future<int> visitorUpdate(Visitor visitor) async {
    _updateVisitor(visitor);
  }

  Future<int> visitorCheckOut(Visitor visitor) async {
//    DateFormat dateFormat = DateFormat('y-MMMM-d').add_jm();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm aa");
    String date = dateFormat.format(DateTime.now());

    List<String> date_b = date.split(" ");
    String time = "${date_b[1]} ${date_b[2]}";

    visitor.time_out = time;

    return await _updateVisitor(visitor);
  }

}