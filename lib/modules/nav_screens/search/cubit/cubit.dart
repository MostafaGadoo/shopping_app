import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/search_model.dart';
import 'package:shopping_app/modules/nav_screens/search/cubit/states.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/end_point.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel searchModel;

  void search(String text){
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text' : text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }
    ).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}