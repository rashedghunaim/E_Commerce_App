import 'package:e_commerce/models/on_boarding_item_model.dart';
import 'package:e_commerce/modules/login/shop_login_screen.dart';
import 'package:e_commerce/network/cash_helper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  final List<OnBoardingItem> _onBoardingItems = [
    OnBoardingItem(
      title: 'on boarding title 1',
      image: 'lib/assets/images/on_boarding.png',
      body: 'onboarding body 1 ',
    ),
    OnBoardingItem(
      title: 'on boarding title 2',
      image: 'lib/assets/images/on_boarding.png',
      body: 'onboarding body 2 ',
    ),
    OnBoardingItem(
      title: 'on boarding title 3',
      image: 'lib/assets/images/on_boarding.png',
      body: 'onboarding body 3 ',
    ),
  ];

  final boardController = PageController();
  bool _isLastItem = false;

  void skipOnBoarding(BuildContext context) {
    CashHelper.saveDataInCash(key: 'onBoardingSkip', value: true)
        .then((future) {
      if (future) {
        print('onBoarding skipped $future');
        Navigator.pushReplacementNamed(context, ShopLoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(top: 20, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Center(
              child: TextButton(
                onPressed: () => skipOnBoarding(context),
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (selectedIndex) {
                  if (selectedIndex == _onBoardingItems.length - 1) {
                    print('last ');
                    _isLastItem = true;
                  } else {
                    print('not the last ');
                    _isLastItem = false;
                  }
                },
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) {
                  return buildOnBoardingItem(_onBoardingItems[index]);
                },
                itemCount: 3,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: _onBoardingItems.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10.0,
                    expansionFactor: 4,
                    dotWidth: 10.0,
                    spacing: 5.0,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (_isLastItem) {
                      skipOnBoarding(context);
                    } else {
                      boardController.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildOnBoardingItem(OnBoardingItem onBoardingItem) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(onBoardingItem.image),
          ),
        ),
        Text(
          onBoardingItem.title,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 15),
        Text(
          onBoardingItem.body,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
