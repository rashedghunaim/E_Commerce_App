class UpdateUserProfileModel {
  bool? status;
  String? message;
  UpdatedUserData? data;


  UpdateUserProfileModel.fromJson({required Map<String, dynamic> jsonData}) {
    status = jsonData['status'];
    message = jsonData['message'];
    data = jsonData['data'] != null
        ? UpdatedUserData.fromJson(jsonData: jsonData['data'])
        : null;
  }
}

class UpdatedUserData {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  int? points;
  int? credit;
  String? token;

  UpdatedUserData.fromJson({required Map<String, dynamic> jsonData}) {
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
