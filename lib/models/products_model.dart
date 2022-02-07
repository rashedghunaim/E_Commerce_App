class HomeProductsModel {
  bool? status;
  String? message;
  DataModel? data;

  HomeProductsModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    message = jsonData['message'];
    data =
        jsonData['data'] != null ? DataModel.fromJson(jsonData['data']) : null;
  }
}

class DataModel {
  List<BannerModel>? banners = [];
  List<ProductsModel>? products = [];

  DataModel.fromJson(Map<String, dynamic> jsonData) {
    jsonData['banners'].forEach((element) {
      banners!.add(BannerModel.fromJson(element));
    });

    jsonData['products'].forEach((element) {
      products!.add(ProductsModel.fromJson(element));
    });
  }
}

class BannerModel {
  int? id;
  String? image;

  BannerModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    image = jsonData['image'];
  }
}

class ProductsModel {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  bool? inFavorite;
  bool? inCart;

  ProductsModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    price = jsonData['price'];
    oldPrice = jsonData['old_price'];
    discount = jsonData['discount'];
    image = jsonData['image'];
    name = jsonData['name'];
    inFavorite = jsonData['in_favorites'];
    inCart = jsonData['in_cart'];
  }
}
