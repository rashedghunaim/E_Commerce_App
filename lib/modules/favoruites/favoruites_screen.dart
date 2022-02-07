import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopCubit = ShopCubit.getShopCubit(context);
        return Conditional.single(
          conditionBuilder: (context) =>
              state is! FetchFavoriteProductsLoadingState,
          context: context,
          widgetBuilder: (context) {
            return ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildListOfProducts(
                  context: context,
                  product: shopCubit.favoriteModel!.data!.data![index].product,
                  isOldPrice: true  ,
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                height: 15.0,
                thickness: 0.50,
              ),
              itemCount: shopCubit.favoriteModel!.data!.data!.length,
            );
          },
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
