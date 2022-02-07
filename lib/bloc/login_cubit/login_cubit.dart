import 'package:bloc/bloc.dart';
import 'package:e_commerce/bloc/login_cubit/states.dart';
import 'package:e_commerce/models/login_model.dart';
import 'package:e_commerce/network/dio_helper.dart';
import 'package:e_commerce/network/end_points(paths).dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(LoginStates initialState) : super(initialState);

  static LoginCubit getLoginCubit(BuildContext context) =>
      BlocProvider.of<LoginCubit>(context);

  LoginModel loginModel = LoginModel.fromJson(jsonData: {});

  Future<void> userLogin(
      {required String email, required String password}) async {
    emit(LoginLoadingState());
    DioHelper.postData(path: loginPath, data: {
      'email': '$email',
      'password': '$password',
    }).then((response) {
      loginModel = LoginModel.fromJson(jsonData: response.data);
      emit(LoginSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  bool isPasswordShown = true;

  IconData passwordIcon = Icons.visibility;

  void togglePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    isPasswordShown
        ? passwordIcon = Icons.visibility
        : passwordIcon = Icons.visibility_off_sharp;
    emit(TogglePasswordVisibilityState());
  }
}
