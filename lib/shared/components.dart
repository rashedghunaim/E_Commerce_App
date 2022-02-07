import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/models/favorie_model.dart';
import 'package:e_commerce/models/search_products_model.dart';
import 'package:e_commerce/modules/login/shop_login_screen.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required String? Function(String?) validateFunction,
  required String label,
  bool obscureText = false,
  void Function()? onSuffixTap,
  IconData? prefixIcon,
  IconData? suffixIcon,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  bool isEnabled = true,
  TextInputType inputType = TextInputType.text,
}) {
  return TextFormField(
    obscureText: obscureText,
    controller: controller,
    keyboardType: inputType,
    validator: validateFunction,
    onTap: onTap,
    onFieldSubmitted: onFieldSubmitted,
    enabled: isEnabled,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: IconButton(
        onPressed: onSuffixTap,
        icon: Icon(suffixIcon),
      ),
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton({
  required String title,
  required void Function() onTap,
  required BuildContext context,
  Color backGroundColor = Colors.blue,
  Color titleColor = Colors.white,
  bool isTitleUpperCase = true,
  double width = double.infinity,
  double height = 40.0,
}) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      isTitleUpperCase ? title.toUpperCase() : title,
      style: TextStyle(
        color: titleColor,
      ),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        backGroundColor,
      ),
      maximumSize: MaterialStateProperty.all(Size(width, height)),
      minimumSize: MaterialStateProperty.all(Size(width, height)),
    ),
  );
}

Future<bool?> showToast(
    {required String message, required ToastStates state}) async {
  return await Fluttertoast.showToast(
    msg: message.toString(),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 5,
    backgroundColor: pickToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color pickToastColor(ToastStates state) {
  Color? color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.greenAccent;
      break;
    case ToastStates.ERROR:
      color = Colors.redAccent;
      break;
    case ToastStates.WARNING:
      color = Colors.amberAccent;
      break;
  }
  return color;
}

Widget buildListOfProducts({
  required BuildContext context,
  required ProductItem? product,
  required bool isOldPrice  ,
}) {
  final shopCubit = ShopCubit.getShopCubit(context);
  return Container(
    margin: EdgeInsets.all(20.0),
    height: 120.0,
    child: Row(
      children: [
        SizedBox(
          width: 120.0,
          height: 120.0,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(product!.image.toString()),
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
              if (product.discount  != 0 && isOldPrice)
                Container(
                  decoration: BoxDecoration(color: Colors.red),
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    product.discount.toString(),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 20.0),
        Expanded(
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
              Spacer(),
              Row(
                children: [
                  Text(
                    product.price.toString(),

                    /// round() will convert the number to int if it came as a double form
                    style: TextStyle(
                      fontSize: 12.0,
                      height: 1.03,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  if (product.discount  != 0 && isOldPrice)
                    Text(
                      product.oldPrice.toString(),

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
