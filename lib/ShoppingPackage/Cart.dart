

class Cart{

  int id,userId,productId,quantity;
  String price;
  String name;

  Cart({this.id,this.userId,this.productId,this.price,this.quantity,this.name});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id : json['id'],
        userId : json['user_id'],
        productId : json['product_id'],
        price : json['price'],
        quantity :  json['quantity'],
        name : json['name']
    );
  }

  Map toGet() {
    var map = new Map<String, dynamic>();
    map['name'] = name.toString();
    map['price'] = price;
    map['quantity'] = quantity.toDouble();
    return map;
  }

}