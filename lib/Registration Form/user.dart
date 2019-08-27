
class User {

  String firstName,lastName,email,password,confirmPassword,privacy;
  int userId;
  bool status;
  User({this.userId,this.firstName,this.lastName,this.email,this.password,this.confirmPassword,this.privacy,this.status});

  factory User.fromJson(Map<String,dynamic>json){

    return User(
      userId: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      status: json['status']
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["email"] = email;
    map["password"] = password;
    map["password_confirmation"] = confirmPassword;
    map["privacy_policy"] = privacy;

    return map;
  }
  Map toLogin() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }

  Map toUpdate() {
    var map = new Map<String, dynamic>();
    map["user_id"] = userId.toString();
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["email"] = email;
    map["password"] = password;
    map["privacy_policy"] = privacy;
   // map["password_confirmation"] = confirmPassword;
    return map;
  }


}