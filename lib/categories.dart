import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyAccount.dart';
import 'ProductPage.dart';
import 'Registration Form/LoginPage.dart';

int id;
// ignore: must_be_immutable
class Categories extends StatefulWidget {
  /*String fullName , email ;

  Categories(this.fullName,this.email);*/

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  String fullName ,first,last, email;


  Future<void> getFullName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.get("firstNamePref")+" "+ prefs.get("lastNamePref");
  }
  Future<void> getID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("idPref");
  }
  Future<void> getFirstName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    first = prefs.get("firstNamePref");
  }

  Future<void> getLastName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    last =prefs.get("lastNamePref");
  }


  Future<void> getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.get("emailPref");

  }

  var isLoading = true;
   List<dynamic> categoryItem;

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

   fetchData() async {
     setState(() {
       isLoading = true;
     });
    final response =
    await http.get('http://global-farm.net/en/api/categories?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv');
   // print(json.decode(response.body));
     categoryItem = json.decode(response.body);

      print(categoryItem[0]["slug"]);

     setState(() {
       isLoading = false;
     });
  }
  
  logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/Categories'));


//     final response = await http.get('http://global-farm.net/en/api/logout?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv');
//      String body = response.body;
//      print(body);
//
//      if(body == 'true'){
//        Navigator.pushNamed(context, '/LoginPage');
//
//      }
//      else{
//        return _showDialog("There is a problem please try again");
//      }
   }

  @override
  void initState() {
    super.initState();
    fetchData();
    getFullName();
    getID();
    getFirstName();
    getLastName();
    getEmail();
    //categoryItem = fetchPost();
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      drawer: buildDrawer(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return isLoading
        ? Scaffold(
      body: Center(child: CircularProgressIndicator()),
    )
        :  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 2.0),
              itemCount: categoryItem.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                   Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProductPage(
                                categoryItem[i]["name"],categoryItem[i]["slug"])));
                  },
                  child: Container(
                    child: Card(
                      elevation: 2,
                      child: Container(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          child: buildTitle(categoryItem[i]['name']),
                        ),
                        /*decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(categories[i]['img']),
                          fit: BoxFit.fill),
                    ),*/
                      ),
                    ),
                  ),
                );
              });


  }

  Widget buildTitle(String title) {
    return Center(
      child: Container(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Colors.white, style: BorderStyle.solid)),
      ),
    );
  }

  Widget buildDrawer() {

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(fullName == null ? "": fullName),
            accountEmail: Text(email== null ? "": email),
            currentAccountPicture: GestureDetector(

            ),
            decoration: new BoxDecoration(color: Colors.green),
          ),

          //body of the drawer
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/Categories');
            },
            child: ListTile(
              title: Text("Home Page"),
              leading: Icon(Icons.home, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new MyAccount(id,first,last,email),
              ));
            },
            child: ListTile(
              title: Text("My Account"),
              leading: Icon(
                Icons.person,
                color: Colors.green,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text("My orders"),
              leading: Icon(Icons.shopping_basket, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/ShoppingPage');
            },
            child: ListTile(
              title: Text("Shopping Cart"),
              leading: Icon(Icons.shopping_cart, color: Colors.green),
            ),
          ),
          InkWell(
            onTap: () {
              logout();
            },
            child: ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.exit_to_app, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}