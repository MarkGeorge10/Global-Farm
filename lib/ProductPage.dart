import 'package:flutter/material.dart';
import 'FavouritePackage/FavouritePage.dart';
import 'Product.dart';
import 'Product_detailed.dart';
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
  var isLoading = true;


  fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get('http://global-farm.net/en/api/products?category='+widget.slug+'&token=hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv   ');
    // print(json.decode(response.body));
    productItem = json.decode(response.body);
    // Product.fromJson(json.decode(response.body));
    productList = new List();

    for (int i=0; i<productItem['data'].length; i++) {
      Product prew = new Product.fromJson(productItem['data'][i]);
      productList.add(prew);
      //print(prew);
    }
    //print(productList[0].name);

    setState(() {
      isLoading = false;
    });
  }

  // ignore: non_constant_identifier_names

  AnimationController _animationController;
  double animationDuration = 0.0;
  int totalItems = 10;

  @override
  void initState() {
    super.initState();
    final int totalDuration = 4000;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));
    animationDuration = totalDuration / (100 * (totalDuration / totalItems));
    _animationController.forward();
    fetchData();
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

            // push data that saved to Favourite Page
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        // ignore: unused_local_variable

                        return FavouritePage(savedFavourite: savedFavourite);
                      },
                    ),
                  );
                }),

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
        body: new Column(
          //verticalDirection: VerticalDirection.down,
          children: <Widget>[
            /*  Hero(
              tag: widget.img,
              child: Image.asset(
                widget.img,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
              ),
            ),*/
            Flexible(
              child: isLoading
                  ? Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
                  : ListView.builder(
                  itemCount: productItem['data'].length,
                  itemBuilder: (context, int index) {
                    return new Item(
                        index: index,
                        pair: productList[index],
                        animationController: _animationController,
                        duration: animationDuration);
                  }),
            )
          ],
        ));
  }

// ignore: missing_return

// This Method build favourite and shopping icon on the card to give beautiful UI

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
          left: MediaQuery.of(context).size.width/20.0),

          child: Row(
          children: <Widget>[

            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    /* setState(() {
                              savedCart[index].quantity--;
                              if (savedCart[index]["quantity"] < 1) {
                                savedCart[index].quantity = 1;
                              }
                            });*/
                  }),
            ),
            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: Text(
                "${1}",
              ),
            ),
            Container(
              margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/30.0) ,
              child: IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    /* setState(() {
                              savedCart[index].quantity++;
                            });*/
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
            onTap: () {
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
