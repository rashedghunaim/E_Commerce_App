import 'package:e_commerce/bloc/login_cubit/login_cubit.dart';
import 'package:e_commerce/bloc/register_cubit/register_cubit.dart';
import 'package:e_commerce/bloc/register_cubit/states.dart';
import 'package:e_commerce/layout/Home_Screen_Bottom_Nav_Bar.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:e_commerce/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class RegisterScreen extends StatelessWidget {
  static final routeName = './Register_Screen';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(RegisterInitialState()),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status == true) {
              CashHelper.saveDataInCash(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                userToken = state.loginModel.data!.token;
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
        },
        builder: (context, state) {
          final registerCubit = RegisterCubit.getRegisterCubit(context);
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
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'register now to browse our new offers ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 50.0),
                        defaultFormField(
                          inputType: TextInputType.name,
                          label: 'User Name',
                          controller: _nameController,
                          isEnabled: true,
                          validateFunction: (value) {
                            if (value!.isEmpty) {
                              return 'pls enter your user name';
                            } else {
                              return null;
                            }
                          },
                          prefixIcon: Icons.person,
                        ),
                        SizedBox(height: 15.0),
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
                          onFieldSubmitted: (_) {},
                          obscureText: registerCubit.isRegisterPasswordShown,
                          onSuffixTap: () =>
                              registerCubit.toggleRegisterPasswordVisibility(),
                          suffixIcon: registerCubit.registerPasswordIcon,
                          prefixIcon: Icons.lock_outline,
                        ),
                        SizedBox(height: 15.0),
                        defaultFormField(
                          inputType: TextInputType.phone,
                          label: 'Phone ',
                          controller: _phoneController,
                          isEnabled: true,
                          validateFunction: (value) {
                            if (value!.isEmpty) {
                              return 'pls enter your phone number ';
                            } else {
                              return null;
                            }
                          },
                          prefixIcon: Icons.phone,
                        ),
                        SizedBox(height: 30.0),
                        Conditional.single(
                          conditionBuilder: (context) =>
                              state is! RegisterLoadingState,
                          context: context,
                          widgetBuilder: (context) => defaultButton(
                            title: 'Register',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                registerCubit
                                    .userRegister(
                                      name: _nameController.text,
                                      phone: _phoneController.text,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
