import 'package:flutter/material.dart';

// ignore: camel_case_types
class Product_detailed extends StatefulWidget {
  final image, name, price,description;

  Product_detailed({this.image, this.name, this.price,this.description});

  @override
  _Product_detailedState createState() => _Product_detailedState();
}

class _Product_detailedState extends State<Product_detailed> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: <Widget>[
          SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Color(0xFF399D63)),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'FROM',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8AC7A4)),
                      ),
                      Text(
                        "\ ${widget.price}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height / 2) - 185.0,
                  left: MediaQuery.of(context).size.width / 2.8,
                  child: Hero(
                    tag: widget.image,
                    child: Image(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.none,
                      //height: 250.0,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.80,
                        left: 20.0,
                        right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Description : ',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600),
                        ),


                        SizedBox(height: 12.0),
                        Text(
                          widget.description == null ? 'If you are completely new to houseplants then Ficus is a brilliant first plant to adopt, it is very easy to look after and won\'t occupy too much space.': widget.description,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
