import 'favorie_model.dart';

class SearchProductsModel {
  bool? status;
  String? message;
  SearchData? data;

  SearchProductsModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    message = jsonData['message'];
    data =
        jsonData['data'] != null ? SearchData.fromJson(jsonData['data']) : null;
  }
}

class SearchData {
  List<ProductItem>? products = [];

  SearchData.fromJson(Map<String, dynamic> jsonData) {
    jsonData['data'].forEach((element) {
      products!.add(ProductItem.fromJson(element));
    });
  }
}

