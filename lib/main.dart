import 'package:bloc/bloc.dart';
import 'package:e_commerce/bloc/shop_cubit/shop_cubit.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:e_commerce/network/dio_helper.dart';
import 'package:e_commerce/shared/constants.dart';
import 'package:e_commerce/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/block_observer.dart';
import 'layout/Home_Screen_Bottom_Nav_Bar.dart';
import 'modules/login/shop_login_screen.dart';
import 'modules/onBoarding/on_boarding_screen.dart';
import 'modules/register/register_screen.dart';
import 'modules/search/search_screen.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DioHelper.initializeDio();
      CashHelper.sharedPref = await SharedPreferences.getInstance();
      bool? isOnBoardingSkipped = CashHelper.getSavedData(key: 'onBoardingSkip');
      userToken = CashHelper.getSavedData(key: 'token');

      print(userToken.toString());

      Widget startWidget = Container();
      if (isOnBoardingSkipped == null) {
        if (userToken == null) {
          startWidget = ShopLoginScreen();
        } else {
          startWidget = HomeScreenBottomNavBar();
        }
      } else {
        startWidget = OnBoardingScreen();
      }

      runApp(AppRoot(startWidget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class AppRoot extends StatelessWidget {
  final Widget startWidget;

  AppRoot(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..fetchHomeData()
            ..fetchCategories()
            ..fetchFavoriteProducts()
            ..getUserProfile(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: startWidget,
        routes: {
          ShopLoginScreen.routeName: (context) => ShopLoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          HomeScreenBottomNavBar.routeName: (context) =>
              HomeScreenBottomNavBar(),
          SearchScreen.routeName: (context) => SearchScreen(),
        },
      ),
    );
  }
}
