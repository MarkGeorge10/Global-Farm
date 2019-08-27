import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_shop/Registration%20Form/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../categories.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();




  Future<User> createPost(String url, {Map body}) async {
    print(body);
    return http.post(url, body: body).then((http.Response response) {

      final String responseBody = response.body;

      User userGet = User.fromJson(json.decode(responseBody));
      //print(responseBody);
      print(userGet.status);

      if (userGet.status) {

        //Navigator.pushNamed(context, '/Categories');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Categories()),
            ModalRoute.withName('/LoginPage'));
        return userGet;
     // return null;
      }

      else{
        _showDialog("There is a problem please try again");
      }
      return null;

    });
  }


  void _showDialog(String str) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: new Text(str),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF399D63), Color(0xFF8EFF84)],
                    ),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50))),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 8,
                left: MediaQuery.of(context).size.width / 20,
                child: Text(
                  'Sign in',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 4,
                child: Container(
                  padding: EdgeInsets.all(32),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(62),
                          topRight: Radius.circular(62))),
                  child: Form(
                  key: _formKey,
                    child: Column(
                      children: <Widget>[
                      TextFormField(
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: "Your Email *",
                        hintText: "Your Email *",
                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Title field cannot be empty";
                        }
                        else {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Please make sure your email address is valid';
                          else
                            return null;
                        }
                      },
                    ),
                        Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 50),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password *',
                                suffixIcon: InkWell(
                                  child: Container(
                                    child: Text(
                                      "Forget?",
                                      style: TextStyle(color: Color(0xFF399D63)),
                                    ),
                                    margin: EdgeInsets.only(top: 15.0, right: 5.0),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            )
                        ),

                        //-------------------------------------Sign In button------------------------

                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, '/Categories');
                              validateForm();
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        // -------------------------------------------------------------



                        //----------------------------Sign Up button---------------------

                        Container(
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 50,
                          ),
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Signup');
                            },
                            child: Center(
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        //--------------------------------------------------------
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> validateForm() async {

    //Navigator.pushNamed(context, '/Categories');
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
     // _makePostRequest(emailController,passwordController);
      User newUser = User(
          email: emailController.text,
          password: passwordController.text,
      );
      User user = await createPost('http://global-farm.net/en/api/login?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',body: newUser.toLogin());
      /*Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Categories()),
          ModalRoute.withName('/LoginPage'));*/
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("idPref", /*3*/user.userId);
      prefs.setString("firstNamePref", /*"omar"*/user.firstName);
      prefs.setString("lastNamePref", /*"saber"*/user.lastName);
      prefs.setString("emailPref", /*"admin@vadecom.net"*/user.email);
      print("hii: ${prefs.get("firstNamePref")}");
//      sharedpref.setString("username", u.firstName);

      formState.reset();
    }

  }
}
