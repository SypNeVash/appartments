import 'package:apartments/app/features/dashboard/controllers/authcontroller.dart';
import 'package:apartments/app/utils/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = true;
  final AuthController authController = Get.find();
  bool showCircular = false;
  String textForerror = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final AuthController authController = Get.find();
    final authController = Get.find<AuthController>();

    return Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Stack(children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // SizedBox(height: size.height * 0.08),
                              const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.06),
                              TextFormField(
                                controller: usernameController,
                                // validator: (value) {
                                //   return Validator.validateName(value ?? "");
                                // },
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: "Ім'я користувача",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              TextFormField(
                                obscureText: _showPassword,
                                controller: passwordController,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                validator: (value) {
                                  return Validator.validatePassword(
                                      value ?? "");
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _showPassword = !_showPassword);
                                    },
                                    child: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Пароль",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                textForerror,
                                style: const TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: size.height * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            showCircular = true;
                                          });

                                          await authController.login(
                                              usernameController.text,
                                              passwordController.text);

                                          if (authController
                                                  .isAuthenticated.value ==
                                              true) {
                                            setState(() {
                                              showCircular = false;
                                            });
                                          } else {
                                            setState(() {
                                              textForerror =
                                                  "Ім'я користувача або пароль є невірним";
                                              showCircular = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            textForerror =
                                                "Ім'я користувача або пароль є невірним";
                                            showCircular = false;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15)),
                                      child: showCircular == true
                                          ? const SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 1.5,
                                              ),
                                            )
                                          : const Text(
                                              "Увійти",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
