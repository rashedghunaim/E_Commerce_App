class CategoryModel {
  bool? status;
  String? message;

  CategoryDataModel? categoryData;

  CategoryModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    message = jsonData['message'];
    categoryData = CategoryDataModel.fromJson(jsonData['data']);
  }
}

class CategoryDataModel {
  List<CategoryItemModel>? data = [];
  int? currentPage;

  CategoryDataModel.fromJson(Map<String, dynamic> jsonData) {
    jsonData['data'].forEach((element) {
      data!.add(CategoryItemModel.formJson(element));
    });
    currentPage = jsonData['current_page'];
  }
}

class CategoryItemModel {
  int? id;
  String? name;
  String? image;

  CategoryItemModel.formJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    name = jsonData['name'];
    image = jsonData['image'];
  }
}
