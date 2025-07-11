class UserModel {
  String? email;
  String? uId;
  bool? isAdmin;
  String? phoneNumber;
  String? aboutMe;
  String? examCreated;
  String? dateJoin;
  String? password;
  String? personImg;
  String? username;

  UserModel({
    this.email,
    this.uId,
    this.isAdmin,
    this.phoneNumber,
    this.aboutMe,
    this.examCreated,
    this.dateJoin,

    this.password,
    this.personImg,
    this.username,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uId = json['uId'];
    isAdmin = json['isAdmin'];
    phoneNumber = json['phoneNumber'];
    aboutMe = json['aboutMe'];
    examCreated = json['examCreated'];
    dateJoin = json['dateJoin'];

    password = json['password'];
    personImg = json['personImg'];
    username = json['username'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uId': uId,
      'isAdmin': isAdmin,
      'phoneNumber': phoneNumber,
      'aboutMe': aboutMe,
      'examCreated': examCreated,
      'dateJoin': dateJoin,
      'password': password,
      'personImg': personImg,
      'username': username,
    };
  }
}
