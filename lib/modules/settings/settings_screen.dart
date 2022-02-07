import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ShopCubit.getShopCubit(context);
        final userModel = cubit.userModel;
        nameController.text = userModel!.data!.name!;
        emailController.text = userModel.data!.email!;
        phoneController.text = userModel.data!.phone!;
        // final updatedUserModel = cubit.updatedUserProfileModel;
        // if (state is FetchUserProfileSate) {
        //   nameController.text = userModel!.data!.name!;
        //   emailController.text = userModel.data!.email!;
        //   phoneController.text = userModel.data!.phone!;
        // } else if (state is UpdateUserProfileState) {
        //   nameController.text = updatedUserModel!.data!.name!;
        //   emailController.text = updatedUserModel.data!.email!;
        //   phoneController.text = updatedUserModel.data!.phone!;
        // }

        return Conditional.single(
          conditionBuilder: (context) => cubit.userModel != null,
          context: context,
          fallbackBuilder: (context) {
            return Center(child: CircularProgressIndicator());
          },
          widgetBuilder: (context) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is UpdateUserProfileLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: nameController,
                      validateFunction: (value) {
                        if (value!.isEmpty) {
                          return 'pls enter your name ';
                        } else {
                          return null;
                        }
                      },
                      label: 'Name',
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(height: 20.0),
                    defaultFormField(
                      controller: emailController,
                      validateFunction: (value) {
                        if (value!.isEmpty) {
                          return 'pls enter your email ';
                        } else {
                          return null;
                        }
                      },
                      label: 'Email Address',
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(height: 20.0),
                    defaultFormField(
                      controller: phoneController,
                      validateFunction: (value) {
                        if (value!.isEmpty) {
                          return 'pls enter your phone number ';
                        } else {
                          return null;
                        }
                      },
                      label: 'Phone',
                      prefixIcon: Icons.phone,
                    ),
                    SizedBox(height: 20.0),
                    defaultButton(
                      context: context,
                      title: 'Sign out',
                      isTitleUpperCase: false,
                      onTap: () {
                        cubit.signOut(context);
                      },
                    ),
                    SizedBox(height: 20.0),
                    defaultButton(
                      context: context,
                      title: 'Update',
                      isTitleUpperCase: false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserProfile(
                            email: emailController.text,
                            name: nameController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
