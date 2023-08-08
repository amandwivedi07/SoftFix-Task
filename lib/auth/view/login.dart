import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/view/signup.dart';
import 'package:flutter_application_1/home/controller/product_provider.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/widget/button.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../home/view/home.dart';
import '../../widget/customtext_field.dart';
import '../model/user.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoggingIn = false;

  @override
  void dispose() {
    Hive.box<User>('users').close();
    Hive.box('login_status').close();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            'Login',
            style: TextStyle(
                fontSize: 30,
                color: darkGreenColor,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 50,
          ),
          MyFormField(
            data: Icons.email,
            controller: emailController,
            hintText: 'Enter Email',
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
            hintText: 'Enter Password',
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    backgroundColor: darkGreenColor,
                    label: 'Submit',
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        if (login(
                            emailController.text, passwordController.text)) {
                          // Login successful, navigate to home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeView()),
                          );
                        } else {
                          // Login failed, show an alert
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Login Failed'),
                                content: Text('Invalid email or password.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Login'),
                              content: Text('Kindly fill all details.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account yet?",
                style: TextStyle(
                    color: darkGreenColor, fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpView();
                    }));
                  },
                  child: Text(
                    'REGISTER HERE',
                    style: TextStyle(
                        color: darkGreenColor, fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ]),
      ),
    );
  }

  bool login(String email, String password) {
    var userBox = Hive.box<User>('users');

    for (var i = 0; i < userBox.length; i++) {
      var user = userBox.getAt(i);
      if (user != null && user.email == email && user.password == password) {
        // Create a copy of the user object before storing
        var userCopy = User()
          ..email = user.email
          ..password = user.password
          ..name = user.name;

        // Save user data to user_profile box
        var userProfileBox = Hive.box<User>('user_profile');
        userProfileBox.put('profile', userCopy);

        // Set the boolean variable to true
        var loginStatusBox = Hive.box('login_status');
        loginStatusBox.put('isLoggedIn', true);

        return true;
      }
    }

    return false;
  }
}
