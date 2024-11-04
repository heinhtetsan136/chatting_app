import 'package:blca_project_app/controller/register/register_event.dart';
import 'package:blca_project_app/controller/register/register_state.dart';
import 'package:blca_project_app/controller/register/resgister_bloc.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final registerbloc = context.read<ResgisterBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: registerbloc.form,
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: IconButton(
                        onPressed: () {
                          StarlightUtils.pushReplacementNamed(
                              RouteNames.loginPage);
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BLCA",
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "App",
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Sign Up",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value?.isNotEmpty != true) {
                            return "Enter Your Email";
                          }
                          return value!.isEmail ? null : "Enter Valid Email";
                        },
                        focusNode: registerbloc.emailFocusNode,
                        onEditingComplete: () {
                          registerbloc.passwordFocusNode.requestFocus();
                        },
                        controller: registerbloc.emailController,
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
                    ),
                    ValueListenableBuilder(
                        valueListenable: registerbloc.passwordIsShow,
                        builder: (_, value, child) {
                          return TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null) return "Password is required";
                              return value.isStrongPassword(
                                minLength: 6,
                                checkUpperCase: false,
                                checkSpecailChar: false,
                              );
                            },
                            obscureText: !value,
                            focusNode: registerbloc.passwordFocusNode,
                            onEditingComplete: () {
                              registerbloc.comfirmPasswordFocusNode
                                  .requestFocus();
                            },
                            controller: registerbloc.passwordController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: registerbloc.showPassword,
                                icon: Icon(
                                  value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              hintText: "Enter Your Password",
                            ),
                          );
                        }),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: ValueListenableBuilder(
                            valueListenable: registerbloc.comfirmpasswordIsShow,
                            builder: (_, value, child) {
                              print(value);
                              return TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value ==
                                          registerbloc.passwordController.text
                                      ? null
                                      : "Password does not match";
                                },
                                obscureText: !value,
                                focusNode:
                                    registerbloc.comfirmPasswordFocusNode,
                                onEditingComplete: () {
                                  registerbloc.comfirmPasswordFocusNode
                                      .unfocus();
                                },
                                controller:
                                    registerbloc.comfirmPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: registerbloc.showComfirmPassword,
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  hintText: "Comfirm Your Password",
                                ),
                              );
                            })),
                    SizedBox(
                        width: context.width,
                        child: ElevatedButton(
                            onPressed: () {
                              registerbloc.add(const OnRegisterEvent());
                            },
                            child:
                                BlocConsumer<ResgisterBloc, RegisterBaseState>(
                                    listener: (_, state) {
                              if (state is RegisterSuccessState) {
                                StarlightUtils.pushReplacementNamed(
                                    RouteNames.homePage);
                              }
                              if (state is RegisterFailedState) {
                                StarlightUtils.dialog(AlertDialog(
                                  title: const Text("Failed to Create"),
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
                            }, builder: (_, state) {
                              if (state is RegisterLoadingState) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              return const Text("Create");
                            }))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              StarlightUtils.pushReplacementNamed(
                                  RouteNames.loginPage);
                            },
                            child: const Text("Login")),
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
