import 'package:e_commerce/bloc/login_cubit/login_cubit.dart';
import 'package:e_commerce/bloc/login_cubit/states.dart';
import 'package:e_commerce/layout/Home_Screen_Bottom_Nav_Bar.dart';
import 'package:e_commerce/modules/register/register_screen.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:e_commerce/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ShopLoginScreen extends StatelessWidget {
  static final String routeName = './shopping_login_screen';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(LoginInitialState()),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.loginModel.status == true) {
            CashHelper.saveDataInCash(
              key: 'token',
              value: state.loginModel.data!.token,
            ).then((value) {
              userToken = state.loginModel.data!.token ;
              print('token has been saved ');
              Navigator.of(context)
                  .pushReplacementNamed(HomeScreenBottomNavBar.routeName);
            });
            print(state.loginModel.message);
          } else {
            showToast(
              message: state.loginModel.message.toString(),
              state: ToastStates.ERROR,
            );
            print(state.loginModel.message);
          }
        }
      }, builder: (context, state) {
        final loginCubit = LoginCubit.getLoginCubit(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'login now to browse our new offers ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 50.0),
                      defaultFormField(
                        inputType: TextInputType.emailAddress,
                        label: 'Email Address',
                        controller: _emailController,
                        isEnabled: true,
                        validateFunction: (value) {
                          if (value!.isEmpty) {
                            return 'pls enter your email address email ';
                          } else {
                            return null;
                          }
                        },
                        prefixIcon: Icons.email,
                      ),
                      SizedBox(height: 15),
                      defaultFormField(
                        inputType: TextInputType.visiblePassword,
                        label: 'Password',
                        controller: _passwordController,
                        isEnabled: true,
                        validateFunction: (value) {
                          if (value!.isEmpty) {
                            return 'pls enter your email email password';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState!.validate()) {
                            loginCubit
                                .userLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                .then((value) => null);
                          }
                        },
                        obscureText: loginCubit.isPasswordShown,
                        onSuffixTap: () {
                          loginCubit.togglePasswordVisibility();
                        },
                        suffixIcon: loginCubit.passwordIcon,
                        prefixIcon: Icons.lock_outline,
                      ),
                      SizedBox(height: 30.0),
                      Conditional.single(
                        conditionBuilder: (context) =>
                            state is! LoginLoadingState,
                        context: context,
                        widgetBuilder: (context) => defaultButton(
                          title: 'LOGIN',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              loginCubit
                                  .userLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  )
                                  .then((value) => null);
                            }
                          },
                          context: context,
                        ),
                        fallbackBuilder: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('don\'t have an account ?'),
                          defaultButton(
                            title: 'register',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            },
                            context: context,
                            isTitleUpperCase: true,
                            backGroundColor: Colors.transparent,
                            titleColor: Theme.of(context).primaryColor,
                            height: 50,
                            width: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
