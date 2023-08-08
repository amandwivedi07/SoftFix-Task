import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/view/login.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../home/controller/product_provider.dart';
import '../../widget/button.dart';
import '../../widget/customtext_field.dart';
import '../model/user.dart';

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final cpasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
    super.dispose();
  }

  bool passwordVisible = false;
  bool cpasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Register',
                style: TextStyle(
                    fontSize: 30,
                    color: darkGreenColor,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 50,
              ),
              MyFormField(
                data: Icons.person,
                controller: nameController,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null; // Return null if validation passes
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyFormField(
                data: Icons.email,
                controller: emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null; // Return null if validation passes
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyFormField(
                obscureText: model.isVisible ? false : true,
                suffixIconData:
                    model.isVisible ? Icons.visibility : Icons.visibility_off,
                data: Icons.lock,
                controller: passwordController,
                hintText: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null; // Return null if validation passes
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: model.cpasswordVisible ? false : true,
                  controller: cpasswordController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: darkGreenColor,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          model.cpasswordVisible = !model.cpasswordVisible;
                        },
                        child: Icon(
                          model.cpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: darkGreenColor,
                          size: 18,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Re-enter Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a confirm password ';
                    } else if (cpasswordController.text !=
                        passwordController.text) {
                      return "Password doesn't matched";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Button(
                          backgroundColor: darkGreenColor,
                          label: 'Sign Up',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              signUp(nameController.text, emailController.text,
                                  passwordController.text, context);
                            }
                          }),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void signUp(
      String name, String email, String password, BuildContext context) async {
    var box = await Hive.openBox<User>('users');

    var newUser = User()
      ..name = name
      ..email = email
      ..password = password;

    await box.add(newUser);
    // Print the contents of the Hive box
    for (var i = 0; i < box.length; i++) {
      var user = box.getAt(i);
      print('User at index $i: ${user?.name}, ${user?.email}');
    }

    Fluttertoast.showToast(
      msg: "User successfully signed up!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Redirect to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }
}
