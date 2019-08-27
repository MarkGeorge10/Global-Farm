import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_shop/Registration%20Form/user.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool hidePass = true;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


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




  Future<User> createPost(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final String responseBody = response.body;

      print(responseBody);

      if (responseBody == 'true') {
        Navigator.pushNamed(context, '/LoginPage');
        return null;//User.fromJson(json.decode(response.body));
      }
      else{
        _showDialog("There is a problem please try again");
      }
      return null;

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF399D63), Color(0xFF8EFF84)],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 25,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 8,
                left: MediaQuery.of(context).size.width / 20,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              // ------------------------------ White Box that contains Text fields and button
              Positioned(
                top: MediaQuery.of(context).size.height / 4.9,
                bottom: MediaQuery.of(context).size.height / 14,
                child: Container(
                  padding: EdgeInsets.all(32),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(62),
                        topRight: Radius.circular(62),
                        bottomLeft: Radius.circular(62),
                        bottomRight: Radius.circular(62),
                      )),

                  //---------------------------------------------------------
                  child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                          ListTile(
                            title: TextFormField(
                              obscureText: false,
                              controller: _firstNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "First Name",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "First name field cannot be empty";
                                } else {
                                    return null;
                                }
                              },
                            ),
                          ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),

                          ListTile(
                            title: TextFormField(
                              obscureText: false,
                              controller: _lastNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Last Name",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Last name field cannot be empty";
                                } else {
                                    return null;
                                }
                              },
                            ),
                          ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),

                      //----------------Email----------------------------------------------------------
                      ListTile(
                        title: TextFormField(
                          obscureText: false,
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email Address",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "The Email field cannot be empty";
                            } else {
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
                      ),
                      //-----------------------------------------------------------
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),
                      //---------------Password-------------------------------------
                      ListTile(
                        title: TextFormField(
                          maxLines: 1,
                          obscureText: hidePass,
                          controller: _passwordTextController,
                          decoration: InputDecoration(
                            hintText: "Create Password",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "The password field cannot be empty";
                            } else if (value.length < 6) {
                              return "At least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye,
                                color: hidePass ? Colors.grey : Colors.green),
                            onPressed: () {
                              setState(() {
                                if (hidePass)
                                  hidePass = false;
                                else
                                  hidePass = true;
                              });
                            }),
                      ),

                      //--------------------------------------------------------------------------

                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),
                      // --------------------------- Confirm password------------------------
                      ListTile(
                        title: TextFormField(
                            obscureText: true,
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "The Password cannot be empty";
                              } else if (_passwordTextController.text !=
                                  _confirmPasswordController.text) {
                                return "Not Matched";
                              }
                              return null;
                            }),
                      ),
                      // ----------------------------------------------------------------------
                     /* SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),
                      //------------------------------Phone------------------------------
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 80,
                        ),
                        child: ListTile(
                          title: TextFormField(
                              obscureText: false,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Enter Your Phone Number",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "The Phone field cannot be empty";
                                } else {
                                 /* Pattern pattern =
                                      r'^((\\+)|(00))[0-9]{6,14}$';
                                  //r'^?\(?\d{3}?\)??-??\(?\d{3}?\)??-??\(?\d{4}?\)??-?$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'your Phone is not qatar number';
                                  else*/
                                    return null;
                                }
                              }),
                        ),
                      ),*/

                      //----------------------------------------------------------

                      //----------------------------Sign Up button---------------------

                      Container(
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 50,
                        ),
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            validateForm();
                          },
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  //--------------------------------------------------------
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      User newUser = User(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailTextController.text,
          password: _passwordTextController.text,
          confirmPassword: _confirmPasswordController.text,
          privacy: "on"
      );

      User u = await createPost('http://global-farm.net/en/api/register?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',body: newUser.toMap());
      print(newUser.toMap());
     // signUp(_firstNameController, _lastNameController, _emailTextController, _passwordTextController,_confirmPasswordController);
      formState.reset();
    }
  }
}
