import 'package:flutter/material.dart';

import '../Product.dart';
import '../Product_detailed.dart';
import '../main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Cart.dart';

class ShoppingPage extends StatefulWidget {
  List<Product> savedCart;

  // Product shoppingpair;
  List<Widget> divided;

  double totalPrice;

  ShoppingPage({this.savedCart});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  var isLoading = true;
  List<dynamic> categoryItem;

  // ignore: missing_return
  fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(
            'http://global-farm.net/en/api/cart?user_id=3token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv')
        .then((http.Response response) {
      categoryItem = json.decode(response.body);

      print(categoryItem);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    fetchData();
  }

  // ignore: missing_return
  Widget buildFavouriteItem(List<dynamic> savedCart) {
    if (savedCart.length == 0) {
      return Center(
        child: Container(
          child: new Text(
            "Your Cart is Empty",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ),
      );
    } else {
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          itemCount: savedCart.length,
          itemBuilder: (context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    onTap: () {
                      /*  Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new Product_detailed(
                                    image: savedShoppingitem[index].picture,
                                    name: savedShoppingitem[index].name,
                                    price: savedShoppingitem[index].price,
                                  ),
                            ));*/
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 10,
                      vertical: MediaQuery.of(context).size.width / 30,
                    ),
                    /*leading: Container(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 20,
                        ),
                        decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.black)),
                        ),
                        child: Image.asset(
                          savedCart[index].picture,
                          fit: BoxFit.fitHeight,
                          width: MediaQuery.of(context).size.width / 8,
                          height: 80.0,
                        ),
                      ),*/
                    title: Center(
                      child: Text(
                        savedCart[index]["name"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 20,
                            decorationColor: Colors.black),
                      ),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 50.0,
                          left: MediaQuery.of(context).size.width/5.0),
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: Container(
                              child: Text("Quantity :",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 15.0),),
                            ),
                          ),
                          Center(
                            child: Container(
                              child: Text(
                                "${savedCart[index]["quantity"]}",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: MediaQuery.of(context).size.width / 25,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30.0),
                      child: Text(
                        "\$${savedCart[index]["price"]}",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: MediaQuery.of(context).size.width / 25,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  double getAmount(List<dynamic> savedCart) {
    double sum = 0.0;

    for (int i = 0; i < 2; i++) {
      sum += double.parse(savedCart[i]["price"]) * savedCart[i]["quantity"];
    }
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
                  if (categoryItem.length != 0) {
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
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text('Your Cart'),
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Your Cart'),
            ),
            //body: ListView(children: widget.divided),
            body: buildFavouriteItem(
              categoryItem,
            ),
            bottomNavigationBar:
                bottomBar(widget.totalPrice = getAmount(categoryItem)),
          );
  }
}
