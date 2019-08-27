class Product {
  String picture;
  String name;
  double price;
  double quantity = 1.0;
  String description;

  Product({this.picture, this.name, this.price, this.quantity, this.description});

   Product.fromJson(Map json) :
      picture = json['files'][0]['path'],
      name =  json['name'],
      price =  num.parse(json['price']['amount']),
      description = json['description'];

  /*Map toAdd() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }*/


}
