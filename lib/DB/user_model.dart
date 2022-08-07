class UserModel{
  String ?email;
  String ?phone;
  String ?password;
  UserModel(this.email,this.phone,this.password);

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'email':email,
      'phone':phone,
      'password':password
    };
    return map;
  }
  UserModel.fromMap(Map<String,dynamic>map){
    email=map['email'];
    phone=map['phone'];
    password=map['password'];
  }
}