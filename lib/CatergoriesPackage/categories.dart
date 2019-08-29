import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_shop/ProductPackage/Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:plant_shop/Registration Form/MyAccount.dart';
import 'package:plant_shop/ProductPackage/ProductPage.dart';
import '../Registration Form/LoginPage.dart';

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


   List<dynamic> categoryItem;


   Future<List<dynamic>>fetchData() async {

    final response =
    await http.get('http://global-farm.net/en/api/categories?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv');
   // print(json.decode(response.body));
     categoryItem = json.decode(response.body);

      print(categoryItem[0]["slug"]);

    return categoryItem;
  }
  
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/Categories'));
   }

  @override
  void initState() {
    super.initState();
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
    return FutureBuilder(
      future: fetchData(),
        builder: (context,snapshot){
        if(snapshot.hasData){
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 2.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {


                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProductPage(
                                snapshot.data[i]["name"],snapshot.data[i]['slug'])));
                  },
                  child: Container(
                    child: Card(
                      elevation: 2,
                      child: Container(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          child: Center(
                            child: Container(
                              child: Text(
                                snapshot.data[i]["name"],
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.white, style: BorderStyle.solid)),
                            ),
                          )
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
        else if(snapshot.hasError){

          Center(
            child: Text("Something happened wrong"),
          );

        }
      return Center(child: CircularProgressIndicator());
    });


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
         /* InkWell(
            onTap: () {},
            child: ListTile(
              title: Text("My orders"),
              leading: Icon(Icons.shopping_basket, color: Colors.green),
            ),
          ),*/
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
