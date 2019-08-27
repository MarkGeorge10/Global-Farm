

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

  Map toAdd() {
    var map = new Map<String, dynamic>();
    map['user_id'] = userId.toString();
    map['product_id'] = productId.toString();
    map['qty'] = quantity.toString();
    return map;
  }



}