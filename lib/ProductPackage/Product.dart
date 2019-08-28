class Product {
  int productId;
  String picture;
  String name;
  double price;
  int quantity ;
  String description;

  Product({this.picture, this.name, this.price, this.quantity, this.description,this.productId});
   Product.fromJson(Map json) :
      picture = json['files'][0]['path'],
      name =  json['name'],
      price =  num.parse(json['price']['amount']),
      description = json['description'],
      productId = json['translations'][0]['product_id'];

  /*Map toAdd() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }*/


}
