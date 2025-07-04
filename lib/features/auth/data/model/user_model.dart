class UserModel {
  num? data;
  String? email;
  String? uId;
  bool? isAdmin;
  String? name;
  String? password;
  String? personImg;
  String? username;

  UserModel({
    this.data,
    this.email,
    this.uId,
    this.isAdmin,
    this.name,
    this.password,
    this.personImg,
    this.username,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    email = json['email'];
    uId = json['uId'];
    isAdmin = json['isAdmin'];
    name = json['name'];
    password = json['password'];
    personImg = json['personImg'];
    username = json['username'];
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'email': email,
      'uId': uId,
      'isAdmin': isAdmin,
      'name': name,
      'password': password,
      'personImg': personImg,
      'username': username,
    };
  }
}
