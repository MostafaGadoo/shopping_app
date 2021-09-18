import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/shoppingapp/shopping_app_layout.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/modules/register/cubit/cubit.dart';
import 'package:shopping_app/modules/register/states.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey =GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (context, state) {
          if(state is ShopRegisterSuccessState){
            if(state.loginModel.status){
              print(state.loginModel.message);
              print(state.loginModel.data.token);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data.token,).
              then((value) {
                token = state.loginModel.data.token;
                navigateAndFinish(context, ShopLayout(),);
              });
              showToast(
                msg: state.loginModel.message,
                state: ToastStates.SUCCESS,
              );
            }else{
              print(state.loginModel.message);
              showToast(
                msg: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Register in now to browse our hot offers',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                        label: 'User Name',
                        prefix: Icons.person,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your email address';
                          }
                        },
                        label: 'Email address',
                        prefix: Icons.email,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          onSubmit:(value){
                            // if(formKey.currentState.validate()){
                            //   ShopRegisterCubit.get(context).userLogin(
                            //     email: emailController.text,
                            //     password: passwordController.text,
                            //   );
                            // }
                          },
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Password is to short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix:ShopRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context).changePasswordVisibility();
                          }
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your Phone Number';
                          }
                        },
                        label: 'Phone number',
                        prefix: Icons.phone,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        builder: (context) => defaultButton(
                          function: () {
                            if(formKey.currentState.validate()){
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'Register',
                          isUpperCase: true,
                        ),
                        condition: state is! ShopRegisterLoadingState,
                        fallback: (context) => Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account account?',
                          ),
                          defaultTextButton(
                            function: (){
                              navigateTo(context, ShopLoginScreen(),);
                            },
                            text: 'Login',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
