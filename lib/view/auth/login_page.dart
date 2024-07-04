import 'package:blca_project_app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                    child: TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.visibility)),
                        hintText: "Enter Your Password",
                      ),
                    ),
                  ),
                  SizedBox(
                      width: context.width,
                      child: ElevatedButton(
                          onPressed: () {
                            StarlightUtils.pushReplacementNamed(
                                RouteNames.homePage);
                          },
                          child: const Text("Login"))),
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
    );
  }
}
