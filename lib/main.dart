import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FavouritePackage/FavouritePage.dart';
import 'PaymenyPackage/PaymentPage.dart';
import 'package:plant_shop/ProductPackage/Product.dart';
import 'Registration Form/LoginPage.dart';
import 'Registration Form/SignUp.dart';
import 'ShoppingPackage/ShoppingPage.dart';
import 'package:plant_shop/CatergoriesPackage/categories.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Product mp;

  Future<String> data;
  Future<int> id;

  Future<String> getFullName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dat = prefs.get("firstNamePref");
    print(dat);
    return dat;
  }
  Future<int> getID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("idPref");
    print(datId);
    return datId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getFullName();
    id = getID();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Shop',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home:  FutureBuilder(
          future: getID(),
          builder: (context, snapshot) {
            if ( snapshot.hasData){
              return Categories();
            }
            return LoginPage();
          },
        ) ,
        routes: {
          '/Categories': (context) => Categories(),
          '/Signup': (context) => SignUp(),
          '/LoginPage': (context) => LoginPage(),
          '/PaymentPage': (context) => PaymentPage(),
          '/ShoppingPage': (context) =>
              ShoppingPage(userId: id),
          '/FavouritePage': (context) => FavouritePage(
            savedFavourite: savedFavourite,
          ),
         // '/MyAccount': (context) => MyAccount(),
        });
  }
}


List<Product> savedShoppingitem = List<Product>();
List<Product> savedFavourite = List<Product>();


