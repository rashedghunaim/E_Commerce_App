class LoginModel {
  bool? status;
  String? message;
  UserData? data;

  // Login({required this.message , required this.status , required this.userData});

  LoginModel.fromJson({required Map<String, dynamic> jsonData}) {
    status = jsonData['status'];
    message = jsonData['message'];
    data = jsonData['data'] != null
        ? UserData.fromJson(jsonData: jsonData['data'])
        : null;
  }
}

class UserData {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  int? points;
  int? credit;
  String? token;

  /// named constructor so we can fetch the data as json then directly initilize the model  .
  UserData.fromJson({required Map<String, dynamic> jsonData}) {
    id = jsonData['id'];
    name = jsonData['name'];
    email = jsonData['email'];
    phone = jsonData['phone'];
    image = jsonData['image'];
    points = jsonData['points'];
    credit = jsonData['credit'];
    token = jsonData['token'];
  }

  /// so the default constructor is not in use right now
// UserLoggedInData({
//   required this.name,
//   required this.id,
//   required this.token,
//   required this.email,
//   required this.image,
//   required this.credit,
//   required this.phone,
//   required this.points,
// });

}
