import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FavouritePackage/FavouritePage.dart';
import 'Product.dart';
import 'Product_detailed.dart';
import 'ShoppingPackage/Cart.dart';
import 'ShoppingPackage/ShoppingPage.dart';
import 'main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Map<String,dynamic> productItem;


// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  final String titleName,slug;

  Product p;

  ProductPage(this.titleName, this.slug);


  @override
  _productListState createState() => _productListState();
}

// ignore: camel_case_types
class _productListState extends State<ProductPage>
    with SingleTickerProviderStateMixin {

  List<Product> productList;




  Future <List<Product>> fetchData() async {
    final response =
    await http.get('http://global-farm.net/en/api/products?category='+widget.slug+'&token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv   ');
    productItem = json.decode(response.body);
    productList = new List();
    Product prew;
    for (int i=0; i<productItem['data'].length; i++) {
       prew = new Product.fromJson(productItem['data'][i]);
      productList.add(prew);
    }
//    print("ssss");
//    print(productList[0].productId);
    return productList;
  }

  // ignore: non_constant_identifier_names

  AnimationController _animationController;
  double animationDuration = 1.5;


  @override
  void initState() {
    super.initState();
    final int totalDuration = 5;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(seconds: totalDuration));
    animationDuration = totalDuration / (4* (totalDuration ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: AppBar(
          title: new Text(
            widget.titleName,
          ),
          backgroundColor: Colors.green,

          //--------------------------------------Action buttons in Appbar ----------------------------------------------
          actions: <Widget>[
            // Add 3 lines from here...

            // push data and Calculate total amount Shopping Page
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return ShoppingPage(savedCart: savedShoppingitem);
                      },
                    ),
                  );
                })
          ],

          //-------------------------------------------------------------------------------------
        ),
        body:
      FutureBuilder(
        future: fetchData(),
          builder: (context,snapshot){

            if (snapshot.hasData) {
              return  ListView.builder(
                  itemCount: snapshot.data.length,

                  itemBuilder: (context, int index) {
                    return new Item(
                        index: index,
                        pair: snapshot.data[index],
                        animationController: _animationController,
                        duration: animationDuration);
                  });
            }
            // ignore: unrelated_type_equality_checks
            else if(snapshot.connectionState == false){return Center(child: Text("Connection Error"));}
            else if (snapshot.hasError) {
              return Center(child: Text("There is Something Problem"));
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());

      }),);
  }

}

class Item extends StatefulWidget {
  final int index;

  final Product pair;
  final AnimationController animationController;
  final double duration;

  Item({this.index,this.pair, this.animationController, this.duration});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Animation _animation;
  double start;
  double end;
  int localQuantity = 1;

  Future<Cart> addCart(String url, {Map body}) async {
    print(body);
    return http.post(url, body: body).then((http.Response response) {

      final String responseBody = response.body;

      //Product userGet = User.fromJson(json.decode(responseBody));
      //print(responseBody);
      print(responseBody);

      /*if (userGet.status) {

        //Navigator.pushNamed(context, '/Categories');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Categories()),
            ModalRoute.withName('/LoginPage'));
        return userGet;
        // return null;
      }

      else{
       // _showDialog("There is a problem please try again");
      }*/
      return null;

    });
  }

  @override
  void initState() {
    super.initState();
    start = (widget.duration * widget.index).toDouble();
    end = start + widget.duration;
    print("START $start , end $end");
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Card(
        elevation: 20.0,
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Product_detailed(
                      image: widget.pair.picture,
                      name: widget.pair.name,
                      price: widget.pair.price,
                    ),
                  ));
            },
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(),
              child:  Image.network(
                widget.pair.picture,
              ),
            ),
            title: Text(
              widget.pair.name,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            subtitle: buildIcon(widget.pair),
            trailing: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 60),
                  child: Text(
                    "${widget.pair.price}",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),

              ],
            )),
      ),
    );
  }

  buildIcon(Product pair) {
    //final model = Provider.of<Model>(context);
    return Row(
      children: <Widget>[


        //--------------------------------------------------------------------------------------

        //----------------------------------Button ADD & Subtract-------------------------------

        Container(
          margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width/30.0),

          child: Row(
          children: <Widget>[

            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    setState(() {
                      localQuantity--;
                      if (localQuantity < 1) {
                        localQuantity = 1;
                      }
                    });


                  }),
            ),
            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: Text(
                "$localQuantity",
              ),
            ),
            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      localQuantity++;
                    });

                  }),
            ),

      ],
    ),
        ),




        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 35,
            left: MediaQuery.of(context).size.width / 8,
          ),
          child: InkWell(
            child: Icon(
                savedShoppingitem.contains(pair)
                    ? Icons.shopping_cart
                    : Icons.add_shopping_cart,
                color: Colors.black
            ),
            onTap: () async {
              pair.quantity = localQuantity;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var datId = prefs.get("idPref");

              Cart newCart = new Cart(
                userId: datId,
                productId: pair.productId,
                quantity: localQuantity,
              );

              Cart cart = await addCart('http://global-farm.net/en/api/cart/items?token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',body: newCart.toAdd());



// Add 9 lines from here...
              setState(() {
                if (savedShoppingitem.contains(pair)) {
                  savedShoppingitem.remove(pair);
                } else {
                  savedShoppingitem.add(pair);
                  print(savedShoppingitem.length.toString());
                }
              });
            },
          ),
        ),
        //-------------------------------------------------------------------------------
      ],
    );
  }
}
