import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:security_logs/models/AppModel.dart';
import 'package:security_logs/screens/visitor_detail.dart';
import 'package:security_logs/utils/db_util.dart';
import 'package:security_logs/models/Visitor.dart';
import 'package:scoped_model/scoped_model.dart';

class VisitorList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VisitorListState();
  }
}

class _VisitorListState extends State<VisitorList> {
  Future<List<Visitor>> visitors;
  Visitor visitorModel;
  AppModel appModel = AppModel();

  // date operations
  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss aa");
  final DateTime today = DateTime.now();

  ValueNotifier<DateTime> tempDate;
  DateFormat displayFormat = DateFormat("EEE d, MMM");

  @override
  void initState() {
    super.initState();
    visitorModel = Visitor();

    tempDate = ValueNotifier<DateTime>(
        today); // add and subtract to temp date, use to query list
    appModel.getVisitorsListDate();
  }

  @override
  Widget build(BuildContext context) {
//    debugPrint("visitor_list.dart temp: ${tempDate.value}");
//    debugPrint("visitor_list.dart temp formatted: ${dateFormat.format(tempDate.value)}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Visitors List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    tempDate.value = tempDate.value.subtract(Duration(days: 1));
                    appModel.getVisitorsListDate(
                        date: dateFormat.format(tempDate.value).split(" ")[0]);
                  },
                  icon: Icon(
                    Icons.arrow_left,
                    color: Colors.black,
                  ),
                ),
                ValueListenableBuilder<DateTime>(
                  valueListenable: tempDate,
                  builder: (context, date, widget) {
                    return GestureDetector(
                      onTap: () {
                        _selectDate();
                      },
                      child: Text(
                        dateFormat.format(date).split(" ")[0].toString() ==
                                dateFormat
                                    .format(today)
                                    .split(" ")[0]
                                    .toString()
                            ? "Today"
                            : displayFormat.format(date),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    DateTime placeholder = tempDate
                        .value; // avoid adding tempdate value while comparing
                    if (placeholder.add(Duration(days: 1)).compareTo(today) <=
                        0) {
                      tempDate.value = tempDate.value.add(Duration(days: 1));
                      appModel.getVisitorsListDate(
                          date:
                              dateFormat.format(tempDate.value).split(" ")[0]);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _getVisitorsList(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      VisitorDetail("Add Visitor", new Visitor())));
        },
        backgroundColor: Color(0xFF059B8D),
        child: Center(
          child: Icon(Icons.add),
        ),
        elevation: 10.0,
        tooltip: "Add A Visitor",
      ),
    );
  }

  Widget _getVisitorsList() {
    return ScopedModel<AppModel>(
      model: appModel,
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
//          return FutureBuilder<List<Visitor>>(
//            future: model.getVisitorsList(),
//            builder: (context, visitorList) {
//              if (visitorList.hasData) {
//                if (visitorList.data.isEmpty) {
//                  return Center(
//                    child: Text(
//                      'No entries available',
//                      style: TextStyle(fontSize: 18.0),
//                    ),
//                  );
//                } else {
//                  debugPrint(
//                      "visitor_list.dart: ${visitorList.data[0].time_in}");
//                  return ListView.builder(
//                    itemCount: visitorList.data.length,
//                    itemBuilder: (context, index) {
//                      return Card(
//                        elevation: 4.0,
//                        color: Colors.white,
//                        child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                          leading: Icon(
//                            Icons.person_outline,
//                            color: Theme.of(context).primaryColor,
//                            size: 40.0,
//                          ),
//                          title: Text(visitorList.data[index].visitor_name),
////                          subtitle: Text(visitorList.data[index].time_in_clock),
//                          subtitle: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Text(
//                                  "Time in: ${visitorList.data[index].time_in}"),
////                              SizedBox(
////                                width: MediaQuery.of(context).size.width * 0.1,
////                              ),
//                              visitorList.data[index].time_out != "" ? Text(
//                                "Time out: ${visitorList.data[index].time_out}",) : SizedBox()
//                            ],
//                          ),
//                          trailing: Container(
//                            width: MediaQuery.of(context).size.width * 0.08,
//                            margin: EdgeInsets.zero,
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                color: _getColor(visitorList.data[index])),
//                          ),
//                          onTap: () {
//                            Navigator.push(
//                                context,
//                                CupertinoPageRoute(
//                                    builder: (context) => VisitorDetail(
//                                        "Edit Visitor",
//                                        visitorList.data[index])));
//                          },
//                        ),
//                      );
//                    },
//                  );
//                }
//              } else if (visitorList.hasError) {
//                debugPrint(
//                    "Error: ${visitorList.error}, data: ${visitorList.data}");
//                return Center(
//                  child: Text("Error fetching visitors list"),
//                );
//              }
//              return Center(
//                child: CupertinoActivityIndicator(
//                  radius: 10.0,
//                ),
//              );
//            },
//          );

          return FutureBuilder<List<Visitor>>(
            future: model.getVisitorsList(),
            builder: (context, visitorList) {
              if (visitorList.hasData) {
                if (model.visitorsListDate.isEmpty) {
                  return Center(
                    child: Text(
                      'No entries available',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                } else if (model.visitorsListDate.isNotEmpty) {
                  return ListView.builder(
                    itemCount: model.visitorsListDate.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(model.visitorsListDate[index].visitor_name),
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).primaryColor,
                              size: 40.0,
                            ),
                            title: Text(
                                model.visitorsListDate[index].visitor_name),
//                          subtitle: Text(visitorList.data[index].time_in_clock),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    "Time in: ${model.visitorsListDate[index].time_in}"),
//                              SizedBox(
//                                width: MediaQuery.of(context).size.width * 0.1,
//                              ),
                                model.visitorsListDate[index].time_out != ""
                                    ? Text(
                                        "Time out: ${model.visitorsListDate[index].time_out}",
                                      )
                                    : SizedBox()
                              ],
                            ),
                            trailing: Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _getColor(model.visitorsListDate[index])),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => VisitorDetail(
                                          "Edit Visitor",
                                          model.visitorsListDate[index])));
                            },
                          ),
                        ),
                        onDismissed: (direction) {
                          model.deleteVisitor(model.visitorsListDate[index]);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Entry deleted."),
                            duration: Duration(milliseconds: 1300),
                          ));
                        },
                      );
                    },
                  );
                }
              }

              return Center(
                child: CupertinoActivityIndicator(
                  radius: 10.0,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: tempDate.value,
        firstDate: tempDate.value.subtract(Duration(days: 30)),
        lastDate: DateTime(2100),
        selectableDayPredicate: (DateTime v) => v.compareTo(today) <= 0);

    if (selectedDate != null && selectedDate != tempDate.value) {
      setState(() {
        tempDate.value = selectedDate;
        appModel.getVisitorsListDate(
            date: dateFormat.format(tempDate.value).split(" ")[0]);
      });
    }
  }

  Color _getColor(Visitor v) {
    if (v.time_out != '') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
