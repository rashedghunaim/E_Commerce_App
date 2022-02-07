import 'package:e_commerce/bloc/search/search_cubit.dart';
import 'package:e_commerce/bloc/search/states.dart';
import 'package:e_commerce/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  static final routeName = './Search_Screen';
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(SearchInitialState()),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final searchCubit = SearchCubit.getSearchCubit(context);
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: searchController,
                      validateFunction: (value) {
                        if (value!.isEmpty) {
                          return 'pls enter text to search ';
                        } else {
                          return null;
                        }
                      },
                      label: 'Search',
                      isEnabled: true,
                      prefixIcon: Icons.search,
                      inputType: TextInputType.text,
                      onFieldSubmitted: (keyword) {
                        searchCubit.searchProducts(
                          keyWord: keyword,
                        );
                      },
                    ),
                    SizedBox(height: 15.0),
                    if (state is SearchProductsLoadingState)
                      LinearProgressIndicator(),
                    if (state is SearchProductsSuccessState)
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildListOfProducts(
                              context: context,
                              product: searchCubit
                                  .searchProductsModel!.data!.products![index],
                              isOldPrice: false ,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                            height: 15.0,
                            thickness: 0.50,
                          ),
                          itemCount: searchCubit
                              .searchProductsModel!.data!.products!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
