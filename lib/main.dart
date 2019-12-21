import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_logs/models/AppModel.dart';
import 'screens/visitor_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF80CBC4),
        fontFamily: 'Raleway',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    final Color _color = Theme.of(context).primaryColor;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            width: _width,
            height: _height * 0.3,
            color: _color,
          ),
          SizedBox(
            height: _height * 0.12,
          ),
          Center(
            child: Container(
              width: _width * 0.8,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your username";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
//                                ),
                                icon: Icon(Icons.person_outline))),
                        SizedBox(
                          height: _height * 0.1,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                              icon: Icon(Icons.lock_outline)),
                          obscureText: true,
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 20.0),
                      child: MaterialButton(
                        color: _color,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => VisitorList()),
                                (_) => false);
                          }
                        },
                        textColor: Colors.white,
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            textScaleFactor: 2,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
