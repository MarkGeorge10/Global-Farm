import 'package:flutter/material.dart';

import '../Product.dart';
import '../Product_detailed.dart';

class FavouritePage extends StatefulWidget {
  List<Product> savedFavourite;
  List<Widget> divided;

  FavouritePage({this.savedFavourite});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  // ignore: missing_return
  Widget buildFavouriteItem(List<Product> savedFavourite) {
    if (savedFavourite.length == 0) {
      return Center(
        child: Container(
          child: new Text(
            "Your Favourite is Empty",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ),
      );
    } else {
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          itemCount: savedFavourite.length,
          itemBuilder: (context, int index) {
            return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Product_detailed(
                              image: savedFavourite[index].picture,
                              name: savedFavourite[index].name,
                              price: savedFavourite[index].price,
                            ),
                      ));
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.black)),
                  ),
                  child:  Image.network(
                      savedFavourite[index].picture,
                      fit: BoxFit.fitHeight,
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),

                title: Center(
                  child: Text(
                    savedFavourite[index].name,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        decorationColor: Colors.black),
                  ),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Center(
                  child: Text(
                    "\$${savedFavourite[index].price}",
                    style: TextStyle(color: Colors.black87, fontSize: 17.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                trailing: Container(
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  margin: EdgeInsets.only(top: 15.0),
                ));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add 6 lines from here...
      appBar: AppBar(
        title: Text('Your Favourites'),
      ),
      body: buildFavouriteItem(widget.savedFavourite),
    ); // ... to here.
  }
}
