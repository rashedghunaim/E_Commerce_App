import 'package:e_commerce/bloc/search/states.dart';
import 'package:e_commerce/models/search_products_model.dart';
import 'package:e_commerce/network/dio_helper.dart';
import 'package:e_commerce/network/end_points(paths).dart';
import 'package:e_commerce/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit(SearchStates initialState) : super(initialState);

  SearchProductsModel? searchProductsModel;

  static SearchCubit getSearchCubit(BuildContext context) =>
      BlocProvider.of<SearchCubit>(context);

  Future<void> searchProducts({required String keyWord}) async {
    emit(SearchProductsLoadingState());
    await DioHelper.postData(
      path: SearchProductsPath,
      data: {'text': keyWord},
      token: userToken,
    ).then((response) {
      searchProductsModel = SearchProductsModel.fromJson(response.data);
      emit(SearchProductsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchProductsErrorState());
    });
  }
}
