import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/shoppingapp/cubit/cubit.dart';
import 'package:shopping_app/layout/shoppingapp/cubit/states.dart';
import 'package:shopping_app/modules/nav_screens/search/search_screen.dart';
import 'package:shopping_app/shared/components/components.dart';

class ShopLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state) {},
      builder: (context,state){
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Marketo',
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: (){
                    navigateTo(context, SearchScreen(),);
                  })
            ],
          ),
          body:cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
              ),
                  label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.apps,
              ),
                  label: 'Categories',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border,
              ),
                  label: 'Favorites',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
              ),
                  label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
