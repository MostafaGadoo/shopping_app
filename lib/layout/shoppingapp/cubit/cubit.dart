  import 'package:bloc/bloc.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:shopping_app/layout/shoppingapp/cubit/states.dart';
import 'package:shopping_app/models/LoginModel.dart';
  import 'package:shopping_app/models/categoriesModel.dart';
import 'package:shopping_app/models/favorite_model.dart';
  import 'package:shopping_app/models/homeModel.dart';
import 'package:shopping_app/models/change_favorites_model.dart';
  import 'package:shopping_app/modules/nav_screens/categories/categories_screen.dart';
  import 'package:shopping_app/modules/nav_screens/favorites/favorites_screen.dart';
  import 'package:shopping_app/modules/nav_screens/products/products_screen.dart';
  import 'package:shopping_app/modules/nav_screens/settings/settings_screen.dart';
  import 'package:shopping_app/shared/components/constants.dart';
  import 'package:shopping_app/shared/network/end_point.dart';
  import 'package:shopping_app/shared/network/remote/dio_helper.dart';

  class ShopCubit extends Cubit<ShopStates>{

    ShopCubit() : super(ShopInitialState());

    static ShopCubit get(context) => BlocProvider.of(context);

    int currentIndex =0;

  List<Widget> bottomScreens = [
    ProductScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index){
    currentIndex= index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel homeModel;

  Map<int,bool> favorites = {};



  void getHomeData(){
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
        url: HOME,
        token: token,
        ).then((value) {
          homeModel = HomeModel.fromJson(value.data);


          homeModel.data.products.forEach((element){
            favorites.addAll({
              element.id : element.inFavorites,
            });
          });
          //print(favorites.toString());

          emit(ShopSuccessHomeDataState());
        }).catchError((error){
          print(error.toString());
          emit(ShopErrorHomeDataState());
        });
  }

  CategoriesModel categoriesModel;
    void getCategories(){
      DioHelper.getData(
        url: GET_CATEGORIES,
      ).then((value) {
        categoriesModel = CategoriesModel.fromJson(value.data);

        emit(ShopSuccessCategoriesState());
      }).catchError((error){
        print(error.toString());
        emit(ShopErrorCategoriesState());
      });
    }

    ChangeFavoritesModel changeFavoritesModel;

    void changeFavorites(int productId) {
      favorites[productId] = !favorites[productId];

      emit(ShopChangeFavoritesState());

      DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id': productId,
        },
        token: token,
      ).then((value) {
        changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
        //print(value.data);

        if (!changeFavoritesModel.status) {
          favorites[productId] = !favorites[productId];
        } else {
          getFavorites();
        }

        emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
      }).catchError((error) {
        favorites[productId] = !favorites[productId];

        emit(ShopErrorChangeFavoritesState());
      });
    }

    FavoritesModel favoritesModel;
    void getFavorites() {
      emit(ShopLoadingGetFavoritesState());

      DioHelper.getData(
        url: FAVORITES,
        token: token,
      ).then((value) {
        favoritesModel = FavoritesModel.fromJson(value.data);
        //printFullText(value.data.toString());

        emit(ShopSuccessGetFavoritesState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopErrorGetFavoritesState());
      });
    }

    ShopLoginModel userModel;
    void getUserDate() {
      emit(ShopLoadingGetUserDataState());

      DioHelper.getData(
        url: PROFILE,
        token: token,
      ).then((value) {
        userModel = ShopLoginModel.fromJson(value.data);
        //printFullText(userModel.data.name);

        emit(ShopSuccessGetUserDataState(userModel));
      }).catchError((error) {
        print(error.toString());
        emit(ShopErrorGetUserDataState());
      });
    }

    void updateUserDate({
    @required String name,
    @required String email,
    @required String phone,
  }) {
      emit(ShopLoadingUpdateUserDataState());

      DioHelper.putData(
        url: UPDATE_PROFILE,
        token: token,
        data: {
          'name' : name,
          'email' : email,
          'phone' : phone,
        }
      ).then((value) {
        userModel = ShopLoginModel.fromJson(value.data);
        //printFullText(userModel.data.name);

        emit(ShopSuccessUpdateUserDataState(userModel));
      }).catchError((error) {
        print(error.toString());
        emit(ShopErrorUpdateUserDataState());
      });
    }
  }