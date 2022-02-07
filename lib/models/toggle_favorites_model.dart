class ToggleFavoritesModel {
  bool status = false;
  String message = '';

  ToggleFavoritesModel.formJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    message = jsonData['message'];
  }
}
