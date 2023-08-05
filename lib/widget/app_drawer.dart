import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/view/login.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:hive/hive.dart';

import '../auth/model/user.dart';
import 'button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var userProfileBox = Hive.box<User>('user_profile');
    var loggedInUser = userProfileBox.get('profile');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: darkGreenColor,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: Icon(
                        Icons.person_3_sharp,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (loggedInUser != null)
                      Text(
                        loggedInUser.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      loggedInUser!.email,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
            child: Button(
                backgroundColor: Colors.red,
                label: 'LOGOUT',
                onPressed: () {
                  logout(context);
                }),
          )
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    var loginBox = Hive.box('login_status');
    loginBox.put('isLoggedIn', false);

    var userProfileBox = Hive.box<User>('user_profile');
    userProfileBox.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginView(), // Navigate to HomeScreen
    ));
  }
}
