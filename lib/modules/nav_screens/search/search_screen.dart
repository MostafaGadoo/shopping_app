import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/shoppingapp/cubit/cubit.dart';
import 'package:shopping_app/modules/nav_screens/search/cubit/cubit.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/styles/colors.dart';

import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state) {},
        builder: (context,state) {
          return  Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'Enter text to search for';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search,
                      onSubmit: (String text){
                          SearchCubit.get(context).search(text);
                      }
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildListProduct(
                          SearchCubit.get(context).searchModel.data.data[index],
                          context,
                          isOldPrice: false,),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: SearchCubit.get(context).searchModel.data.data.length,
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
