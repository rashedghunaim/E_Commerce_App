class RegisterModel {
  bool? status;
  String? message;
  RegisterData? data;

  RegisterModel.fromJson({required Map<String, dynamic> jsonData}) {
    status = jsonData['status'];
    message = jsonData['message'];
    data = jsonData['data'] != null
        ? RegisterData.fromJson(jsonData: jsonData['data'])
        : null;
  }
}

class RegisterData {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  int? points;
  int? credit;
  String? token;

  /// named constructor so we can fetch the data as json then directly initilize the model  .
  RegisterData.fromJson({required Map<String, dynamic> jsonData}) {
    id = jsonData['id'];
    name = jsonData['name'];
    email = jsonData['email'];
    phone = jsonData['phone'];
    image = jsonData['image'];
    points = jsonData['points'];
    credit = jsonData['credit'];
    token = jsonData['token'];
  }
}
