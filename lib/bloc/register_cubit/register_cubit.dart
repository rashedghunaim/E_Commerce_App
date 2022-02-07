import 'package:bloc/bloc.dart';
import 'package:e_commerce/bloc/register_cubit/states.dart';
import 'package:e_commerce/models/login_model.dart';
import 'package:e_commerce/models/register_model.dart';
import 'package:e_commerce/network/dio_helper.dart';
import 'package:e_commerce/network/end_points(paths).dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(RegisterStates initialState) : super(initialState);

  static RegisterCubit getRegisterCubit(BuildContext context) =>
      BlocProvider.of<RegisterCubit>(context);

  RegisterModel registerModel = RegisterModel.fromJson(jsonData: {});

  Future<void> userRegister(
      {required String email,
      required String password,
      required String phone,
      required String name}) async {
    emit(RegisterLoadingState());
    DioHelper.postData(path: RegisterPath, data: {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
    }).then((response) {
      registerModel = RegisterModel.fromJson(jsonData: response.data);
      emit(RegisterSuccessState(registerModel));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  bool isRegisterPasswordShown = true;
  IconData registerPasswordIcon = Icons.visibility;

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordShown = !isRegisterPasswordShown;
    isRegisterPasswordShown
        ? registerPasswordIcon = Icons.visibility
        : registerPasswordIcon = Icons.visibility_off_sharp;
    emit(TogglePasswordRegisterVisibilityState());
  }
}
