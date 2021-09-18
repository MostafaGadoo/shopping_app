import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/shoppingapp/cubit/cubit.dart';
import 'package:shopping_app/layout/shoppingapp/cubit/states.dart';
import 'package:shopping_app/models/categoriesModel.dart';
import 'package:shopping_app/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,index){},
      builder: (context, index){
        return ListView.separated(
          itemBuilder: (context, index) => buildCategoriesItem(cubit.categoriesModel.data.data[index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: cubit.categoriesModel.data.data.length,
        );
      },

    );
  }


}

Widget buildCategoriesItem(DataModel model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Image(
        image: NetworkImage(model.image),
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
      ),
      SizedBox(
        width: 20.0,
      ),
      Text(
        model.name,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Spacer(),
      Icon(
        Icons.arrow_forward_ios,
      ),
    ],
  ),
);
