import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:security_logs/models/AppModel.dart';
import 'package:security_logs/models/Visitor.dart';
import 'package:intl/intl.dart';

class VisitorDetail extends StatefulWidget {
  String title;
  Visitor visitor;

  VisitorDetail(this.title, this.visitor);

  @override
  State<StatefulWidget> createState() {
    return _VisitorDetailState();
  }
}

class _VisitorDetailState extends State<VisitorDetail> {
  final _formKey = GlobalKey<FormState>();
  Visitor visitorModel = Visitor();
  AppModel appModel = AppModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController visitingController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  Visitor visitor;
  bool disableCheckIn;
  bool disableCheckOut;
  bool disableUpdateDetail;

  @override
  void initState() {
    visitor = widget.visitor;
    nameController.text = widget.visitor.visitor_name;
    visitingController.text = widget.visitor.person_visiting;
    phoneNoController.text = widget.visitor.phoneNo;

    if (widget.title.toLowerCase() == "add visitor") {
      disableCheckIn = false;
    } else {
      disableCheckIn = true;
    }

    if (visitor.time_out == '') {
      disableCheckOut = false;
      disableUpdateDetail = false;
    } else {
      disableCheckOut = true;
      disableUpdateDetail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the visitors name.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Visitors Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  TextFormField(
                    controller: phoneNoController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the visitors phone number.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  TextFormField(
                    controller: visitingController,
                    decoration: InputDecoration(
                      labelText: "Who to Visit",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: disableCheckIn ? null : () => checkIn(),
                        color: Colors.green,
                        disabledColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        textColor: Colors.white,
                        child: Text(
                          "Check In",
                          textScaleFactor: 1.2,
                        ),
                      ),
                      MaterialButton(
                        onPressed:
                            disableUpdateDetail ? null : () => updateDetails(),
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        child: Text(
                          "Update Details",
                          textScaleFactor: 1.2,
                        ),
                      ),
                      MaterialButton(
                        onPressed: disableCheckOut ? null : () => checkOut(),
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        child: Text(
                          "Check Out",
                          textScaleFactor: 1.2,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkIn() async {
    if (_formKey.currentState.validate()) {
      // set the visitors name
      visitor.visitor_name = nameController.text;

      // visiting name
      visitor.person_visiting = visitingController.text;

      // phone number
      visitor.phoneNo = phoneNoController.text;

      int result;
      result = await appModel.visitorCheckIn(visitor);

      if (result != 0) {
        showAlertDialog(nameController.text, "Checked in Successfully.");
        disableCheckIn = true;
      } else {
        showAlertDialog("Error", "Couldn't check in $nameController");
      }
    }
  }

  void updateDetails() async {
    // set the visitors name
    visitor.visitor_name = nameController.text;

    // visiting name
    visitor.person_visiting = visitingController.text;

    // phone number
    visitor.phoneNo = phoneNoController.text;

    int result = await appModel.visitorUpdate(visitor);

    if (result != 0) {
      showAlertDialog(nameController.text, "Details Updated.");
    } else {
      showAlertDialog("Error", "Couldn't check in $nameController");
    }
  }

  void checkOut() async {
    DateFormat dateFormat = DateFormat('y-MMMM-d').add_jm();
    String date = dateFormat.format(DateTime.now());
    visitor.time_out = date;

    int result;
    result = await appModel.visitorCheckOut(visitor);
    if (result != 0) {
      disableCheckOut = true;
      disableUpdateDetail = true;
      showAlertDialog(visitor.visitor_name, "Checked out Successfully.");
    } else {
      showAlertDialog(
          "Error", "Couldn't check out $nameController, please try again.");
    }
  }

  void showAlertDialog(String name, String content) {
    AlertDialog alertDialog = new AlertDialog(
      title: Text(name),
      content: Text(content),
    );
    Navigator.pop(context);
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
