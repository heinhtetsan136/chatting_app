import 'package:blca_project_app/controller/login/login_bloc.dart';
import 'package:blca_project_app/controller/login/login_event.dart';
import 'package:blca_project_app/controller/login/login_state.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginbloc = context.read<LoginBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: loginbloc.formKey,
        child: Container(
          width: context.width,
          height: context.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                Color.fromRGBO(251, 250, 254, 1),
                Color.fromRGBO(242, 249, 252, 1),
                Color.fromRGBO(229, 234, 251, 1),
              ])),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BLCA",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "App",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: loginbloc.emailFocusNode,
                        controller: loginbloc.emailController,
                        onEditingComplete: () {
                          loginbloc.passwordFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value?.isNotEmpty != true) {
                            return "Please Enter Email";
                          }
                          return value!.isEmail == true
                              ? null
                              : "Please Enter Valid Email";
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter Your Email",
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ValueListenableBuilder(
                          valueListenable: loginbloc.passwordIsShow,
                          builder: (_, value, child) {
                            return TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: !value,
                                onEditingComplete: () {
                                  loginbloc.passwordFocusNode.unfocus();
                                },
                                controller: loginbloc.passwordController,
                                focusNode: loginbloc.passwordFocusNode,
                                validator: (value) {
                                  if (value == null) {
                                    return "Password is required";
                                  }
                                  return value.isStrongPassword(
                                    minLength: 6,
                                    checkUpperCase: false,
                                    checkSpecailChar: false,
                                  );
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      loginbloc.showPassword();
                                    },
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  hintText: "Enter Your Password",
                                ));
                          }),
                    ),
                    SizedBox(
                        width: context.width,
                        child: ElevatedButton(
                            onPressed: () {
                              loginbloc.add(const OnLogin());
                            },
                            child: BlocConsumer<LoginBloc, LoginBaseState>(
                                builder: (_, state) {
                              if (state is LoginLoading) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              return const Text("Login");
                            }, listener: (_, state) {
                              if (state is LoginSuccess) {
                                StarlightUtils.pushReplacementNamed(
                                    RouteNames.homePage);
                              }
                              if (state is LoginFailed) {
                                StarlightUtils.dialog(AlertDialog(
                                  title: const Text("Login Failed"),
                                  content: Text(state.message),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          StarlightUtils.pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                ));
                              }
                            }))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Create new account ?"),
                        TextButton(
                            onPressed: () {
                              StarlightUtils.pushNamed(RouteNames.signUpPage);
                            },
                            child: const Text("Sign Up")),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
