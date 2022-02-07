import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/models/categories_model.dart';
import 'package:e_commerce/models/products_model.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ToggleFavoritesSuccessStatusState) {
          if (state.favoriteModel.status == false) {
            showToast(
              state: ToastStates.ERROR,
              message: state.favoriteModel.message,
            );
          }
        }
      },
      builder: (context, state) {
        final shopCubit = ShopCubit.getShopCubit(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              shopCubit.homeProductsModel != null && shopCubit.categoryModel != null,
          widgetBuilder: (context) => productsHomeBuilder(
              shopCubit.homeProductsModel, context, shopCubit.categoryModel),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsHomeBuilder(
      HomeProductsModel? model, BuildContext context, CategoryModel? category) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model!.data!.banners!.map((banner) {
              return Image(
                image: NetworkImage('${banner.image}'),
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }).toList(),
            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 100.0,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => categoryItemBuilder(
                        category!.categoryData!.data![index]),
                    separatorBuilder: (context, index) => Divider(indent: 15.0),
                    itemCount: category!.categoryData!.data!.length,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'New Products',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,

              /// main means the au and down
              crossAxisSpacing: 1.0,

              /// cross l;eft and right .
              childAspectRatio: 1 / 1.5,

              /// width / length
              children: List.generate(model.data!.products!.length, (index) {
                return gridProductItem(model.data!.products![index], context);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget gridProductItem(ProductsModel product, BuildContext context) {
  // print(product.id);
  // print(product.name);
  final shopCubit = ShopCubit.getShopCubit(context);
  return Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage('${product.image}'),
              width: double.infinity,
              height: 200.0,
            ),
            if (product.discount != 0)
              Container(
                decoration: BoxDecoration(color: Colors.red),
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'DISCOUNT',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.0,
                  height: 1.03,
                ),
              ),
              Row(
                children: [
                  Text(
                    product.price.round().toString(),

                    /// round() will convert the number to int if it came as a double form
                    style: TextStyle(
                      fontSize: 12.0,
                      height: 1.03,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  if (product.discount != 0)
                    Text(
                      '${product.oldPrice.round()}',

                      /// round() will convert the number to int if it came as a double form
                      style: TextStyle(
                        fontSize: 10.0,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      shopCubit.toggleFavorites(productID: product.id);
                    },
                    icon: CircleAvatar(
                      backgroundColor: shopCubit.favorites[product.id] == true
                          ? Colors.red
                          : Colors.grey,
                      radius: 15.0,
                      child: Icon(
                        Icons.favorite_border,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget categoryItemBuilder(CategoryItemModel? category) {
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage('${category!.image}'),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        width: 100.0,
        child: Text(
          category.name.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    ],
  );
}
