import 'package:e_commerce/models/register_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}
class RegisterLoadingState extends RegisterStates {}
class RegisterSuccessState extends RegisterStates {
  final RegisterModel loginModel ;
  RegisterSuccessState(this.loginModel);
}
class RegisterErrorState extends RegisterStates {
  final String error ;
  RegisterErrorState(this.error) ;
}
class TogglePasswordRegisterVisibilityState extends RegisterStates {}