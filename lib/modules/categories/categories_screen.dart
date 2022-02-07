import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopCubit = ShopCubit.getShopCubit(context);
        return ListView.separated(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return buildCategoryItem(
                categoryItem:
                    shopCubit.categoryModel!.categoryData!.data![index]);
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            height: 15.0,
            thickness: 0.50,
          ),
          itemCount: shopCubit.categoryModel!.categoryData!.data!.length,
        );
      },
    );
  }
}

Widget buildCategoryItem({required CategoryItemModel? categoryItem}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage('${categoryItem!.image}'),
          fit: BoxFit.cover,
          height: 120.0,
          width: 120.0,
        ),
        SizedBox(width: 20.0),
        Text(
          categoryItem.name.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios)
      ],
    ),
  );
}
