import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: must_be_immutable


class ShoppingPage extends StatefulWidget {

  Future<int> userId;

  double totalPrice;

  ShoppingPage({this.userId});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {

  List<dynamic> cartItem;


  @override
  // ignore: must_call_super
  Future<List<dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("idPref");
    final response = await http
        .get('http://global-farm.net/en/api/cart?user_id=' +
            '$datId' +
            'token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv')
        .then((http.Response response) {
      cartItem = json.decode(response.body);
      print(cartItem);


    });
    return cartItem;
  }

  deleteData(int userId, int productId) async {
    final response = await http
        .get('http://global-farm.net/en/api/cart/delete?user_id=' +
            '$userId' +
            '&product_id=' +
            '$productId' +
            '&token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv')
        .then((http.Response response) {
      String responseBody = json.decode(response.body);
      print(responseBody);
    });
  }

  // ignore: missing_return
  Widget buildFavouriteItem() {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Your Cart",
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          // Add 3 lines from here...

          // push data and Calculate total amount Shopping Page
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ShoppingPage()));
              })
        ],

      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
             if (snapshot.data.length == 0) {
              return Material(

                child: Center(
                  child: Container(
                    child: new Text(
                      "Your Cart is Empty",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),
              );
            }
              return Scaffold(

                body: ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(
                          color: Colors.black,
                        ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: ListTile(
                              onTap: () {},
                              contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 10,
                                vertical: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 30,
                              ),
                              title: Center(
                                child: Text(
                                  snapshot.data[index]["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 20,
                                      decorationColor: Colors.black),
                                ),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Container(
                                margin: EdgeInsets.only(
                                    top:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height / 50.0,
                                    left:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width / 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Price :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "\$${snapshot.data[index]["price"]}",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width /
                                                  25,
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Quantity :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "${snapshot.data[index]["quantity"]}",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width /
                                                  25,
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.black,
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    int datUser = prefs.get("idPref");
                                    setState(() {
                                      deleteData(datUser,
                                          snapshot.data[index]["product_id"]);
                                    });
                                  }),
                            ),
                          ),
                        ],
                      );
                    }),
                bottomNavigationBar: bottomBar(widget.totalPrice = getAmount(snapshot.data)),
              );
            }

            // ignore: unrelated_type_equality_checks
            else if (snapshot.connectionState == false) {
              return Center(child: Text("Connection Error"));
            }
            else if (snapshot.hasError) {
              return Center(child: Text("There is Something Problem"));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  double getAmount(List<dynamic> savedCart) {
    double sum = 0.0;

    for (int i = 0; i < savedCart.length; i++) {
      sum += double.parse(savedCart[i]["price"]) * savedCart[i]["quantity"];
    }
    print(sum);
    return sum;
  }

  Widget bottomBar(double d) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        // color: Colors.white,
        child: new Row(
          children: <Widget>[
            Expanded(
                child: new ListTile(
              leading: new Text(
                "Total: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.red),
              ),
              title: new Text(
                "\$$d",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                ),
              ),
            )),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  if (cartItem.length != 0) {
                    Navigator.pushNamed(context, '/PaymentPage');
                  }
                },
                child: new Text(
                  "Check out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildFavouriteItem();
  }
}
