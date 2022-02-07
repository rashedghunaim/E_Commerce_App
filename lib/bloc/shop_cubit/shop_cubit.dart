import 'package:bloc/bloc.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/models/categories_model.dart';
import 'package:e_commerce/models/favorie_model.dart';
import 'package:e_commerce/models/login_model.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:e_commerce/models/search_products_model.dart';
import 'package:e_commerce/models/toggle_favorites_model.dart';
import 'package:e_commerce/models/update_user_profile_model.dart';
import 'package:e_commerce/modules/categories/categories_screen.dart';
import 'package:e_commerce/modules/favoruites/favoruites_screen.dart';
import 'package:e_commerce/modules/login/shop_login_screen.dart';
import 'package:e_commerce/modules/products/products_screen.dart';
import 'package:e_commerce/modules/settings/settings_screen.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:e_commerce/network/dio_helper.dart';
import 'package:e_commerce/network/end_points(paths).dart';
import 'package:e_commerce/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit getShopCubit(BuildContext context) =>
      BlocProvider.of<ShopCubit>(context);

  int currentIndex = 0;
  List<Widget> screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomNavigatorBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites '),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void toggleBottomNavigationBar(int selectedIndex) {
    currentIndex = selectedIndex;
    emit(ToggleBottomNavigatorBarState());
  }

  HomeProductsModel? homeProductsModel;
  Map<int?, bool?> favorites = {};

  void fetchHomeData() {
    emit(FetchHomeDataLoadingState());
    DioHelper.fetchData(path: HomePath, query: null, token: userToken)
        .then((response) {
      homeProductsModel = HomeProductsModel.fromJson(response.data);
      homeProductsModel!.data!.products!.forEach((product) {
        favorites.putIfAbsent(product.id, () => product.inFavorite);
      });

      print(favorites.toString());
      // printWholeText(homeModel!.data!.banners![0].id.toString());
      // print(homeModel!.status);
      emit(FetchHomeDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(FetchHomeDataErrorState());
    });
  }

  CategoryModel? categoryModel;

  void fetchCategories() {
    DioHelper.fetchData(path: CategoriesPath, lang: 'en', query: null)
        .then((response) {
      categoryModel = CategoryModel.fromJson(response.data);
      emit(FetchCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(FetchCategoriesErrorDataState());
    });
  }

  ToggleFavoritesModel? toggleFavoritesModel;

  void toggleFavorites({required int? productID}) {
    if (favorites[productID] == true) {
      favorites[productID] = false;
      emit(ToggleFavoritesSuccessState());

      /// the purpose from the favorite map is that it appears for the user as we are toggling as real time
      /// but actually its not real time talking  .
      /// because the when we toggle favorites method it will take sometime until the response arrive
      ///
    } else {
      favorites[productID] = true;
      emit(ToggleFavoritesSuccessState());
    }

    DioHelper.postData(
      path: FavoritesPath,
      data: {'product_id': productID},
      token: userToken,
    ).then((response) {
      toggleFavoritesModel = ToggleFavoritesModel.formJson(response.data);
      print(toggleFavoritesModel!.message.toString());

      if (toggleFavoritesModel!.status == false) {
        /// the idea here if the status from the api is false that means that the process of the request is not done .
        /// so for that me must make sure that when toggling the favorite at first and the status is false . thn we must make sure its the opposite .
        if (favorites[productID] == true) {
          favorites[productID] = false;
        } else {
          favorites[productID] = true;
        }
      } else {
        fetchFavoriteProducts();
      }
      emit(ToggleFavoritesSuccessStatusState(toggleFavoritesModel!));
    }).catchError((error) {
      print(error.toString());
      if (toggleFavoritesModel!.status == false) {
        if (favorites[productID] == true) {
          favorites[productID] = false;
        } else {
          favorites[productID] = true;
        }
      }
      emit(ToggleFavoritesErrorState());
    });
  }

  FavoriteModel? favoriteModel;

  Future<void> fetchFavoriteProducts() async {
    emit(FetchFavoriteProductsLoadingState());
    await DioHelper.fetchData(path: FavoritesPath, token: userToken, lang: 'en')
        .then((response) {
      favoriteModel = FavoriteModel.fromJson(response.data);
      print('the favorites data ${favoriteModel!.data!.data}');
      emit(FetchFavoriteProductsState());
    }).catchError((error) {
      print(error.toString());
      emit(FetchFavoriteProductsErrorState());
    });
  }

  LoginModel? userModel;

  Future<void> getUserProfile() async {
    emit(FetchUserProfileLoadingSate());
    await DioHelper.fetchData(path: ProfilePath, token: userToken, lang: 'en')
        .then((response) {
      userModel = LoginModel.fromJson(jsonData: response.data);
      print(userModel!.data!.name);
      emit(FetchUserProfileSate(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(FetchUserProfileErrorSate());
    });
  }

  UpdateUserProfileModel? updatedUserProfileModel;

  Future<void> updateUserProfile(
      {required String? name,
      required String? phone,
      required String? email}) async {
    emit(UpdateUserProfileLoadingState());
    await DioHelper.putData(
      path: UpdateUserProfilePath,
      data: {
        'email': email,
        'phone': phone,
        'name': name,
      },
      token: userToken,
    ).then((response) {
      // updatedUserProfileModel =
      //     UpdateUserProfileModel.fromJson(jsonData: response.data);
      userModel = LoginModel.fromJson(jsonData: response.data);
      emit(UpdateUserProfileState());
    }).catchError((error) {
      emit(UpdateUserProfileErrorState());
    });
  }

  void signOut(BuildContext context) {
    print('sign out');
    CashHelper.removeData(key: 'token').then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, ShopLoginScreen.routeName);
      }
    });
  }




}
