import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Registration Form/user.dart';

// ignore: must_be_immutable
class MyAccount extends StatefulWidget {
   String first,last,email;
   int id;
   MyAccount(this.id,this.first,this.last,this.email);


  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  bool hidePass = true;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
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
  

  Future<User> updateProfile(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final String responseBody = response.body;
      print("response: $responseBody");
      //User userGet = User.fromJson(json.decode(responseBody));


     // print(userGet.status);

      if (responseBody == 'true') {
        _showDialog("Your Data updated successfully");
        return null;
      }
      else{
        _showDialog("There is a problem please try again");
      }
      return null;

    });
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "My Account",
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
      ),
      body: Form(
      key: _formKey,
      child: ListView(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 50,
        ),
        //----------------Email----------------------------------------------------------
        ListTile(
          title: TextFormField(
          //  initialValue: _firstNameController.toString(),
            obscureText: false,
            controller: _firstNameController,
           // keyboardType: TextInputType.text,

            decoration: InputDecoration(
              hintText: widget.first,

            ),

          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 80,
        ),

        ListTile(
          title: TextFormField(
            obscureText: false,
            controller: _lastNameController,
            //keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.last,
            ),

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
              hintText: widget.email,
            ),

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
             ),
        ),

        //----------------------------------------------------------

        //----------------------------Sign Up button---------------------

        Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 50,
          ),
          height: MediaQuery.of(context).size.height / 15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: FlatButton(
            onPressed: () async {
              validateForm();
            },
            child: Center(
              child: Text(
                'Update your data',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ]),
    ),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      User updatedUser = User(
          userId: widget.id,
          firstName: _firstNameController.text == "" ? widget.first : _firstNameController.text,
          lastName: _lastNameController.text == "" ? widget.last : _lastNameController.text,
          email: _emailTextController.text == "" ? widget.email : _emailTextController.text,
          password: _passwordTextController.text,
         // confirmPassword: _confirmPasswordController.text,
        privacy: "on"

      );


      User u = await updateProfile('http://global-farm.net/en/api/account/profile?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',body: updatedUser.toUpdate());
      print("238 ${updatedUser.toMap()}");
      formState.reset();
    }
  }
}
