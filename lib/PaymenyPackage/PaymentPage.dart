import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var items = [
    {
      'title': 'PayPal',
      'img': 'img/paypal.png',
    },
    {
      'title': 'Master Card',
      'img': 'img/mastercard.png',
    },
    {
      'title': 'Westearn Union',
      'img': 'img/westernunion.png',
    },
    {
      'title': 'Visa',
      'img': 'img/visa.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
          child: ListTile(
            title: Center(
              child: Text(
                items[i]['title'],
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
            ),
            leading: Container(
              color: Colors.white,
              child: Image.asset(
                items[i]['img'],
              ),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
            subtitle: Text(
              " ",
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
