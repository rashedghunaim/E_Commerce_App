import 'package:e_commerce/models/login_model.dart';
import 'package:e_commerce/models/toggle_favorites_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ToggleBottomNavigatorBarState extends ShopStates {}

class FetchHomeDataLoadingState extends ShopStates {}

class FetchHomeDataSuccessState extends ShopStates {}

class FetchHomeDataErrorState extends ShopStates {}

class FetchCategoriesSuccessState extends ShopStates {}

class FetchCategoriesErrorDataState extends ShopStates {}

class ToggleFavoritesSuccessState extends ShopStates {}

class ToggleFavoritesSuccessStatusState extends ShopStates {
  final ToggleFavoritesModel favoriteModel;

  ToggleFavoritesSuccessStatusState(this.favoriteModel);
}

class ToggleFavoritesErrorState extends ShopStates {}

class FetchFavoriteProductsLoadingState extends ShopStates {}

class FetchFavoriteProductsState extends ShopStates {}

class FetchFavoriteProductsErrorState extends ShopStates {}

class FetchUserProfileLoadingSate extends ShopStates {}

class FetchUserProfileSate extends ShopStates {
  final LoginModel loginUserModel;

  FetchUserProfileSate(this.loginUserModel);
}

class FetchUserProfileErrorSate extends ShopStates {}



class UpdateUserProfileLoadingState extends ShopStates {}
class UpdateUserProfileState extends ShopStates {}
class UpdateUserProfileErrorState extends ShopStates {}



