import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/bloc/shop_cubit/states.dart';
import 'package:e_commerce/modules/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBottomNavBar extends StatelessWidget {
  static final routeName = './ShopLayoutHomeScreen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopCubit = ShopCubit.getShopCubit(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('salla'),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(SearchScreen.routeName),
                icon: Icon(Icons.search),
              ),
            ],
          ),
          body: shopCubit.screens[shopCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(

            currentIndex: shopCubit.currentIndex,
            onTap: (selectedIndex) {
              shopCubit.toggleBottomNavigationBar(selectedIndex);
            },
            items: shopCubit.bottomNavigatorBarItems,
          ),
        );
      },
    );
  }
}
