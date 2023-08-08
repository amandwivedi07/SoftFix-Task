import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/view/login.dart';
import 'package:flutter_application_1/home/view/home.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'auth/model/user.dart';
import 'home/controller/product_provider.dart';
import 'home/model/hive_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<User>('user_profile');
  await Hive.openBox('login_status');

  await Hive.openBox<Product>('cart');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var loginStatusBox = Hive.box('login_status');
    bool isLoggedIn = loginStatusBox.get('isLoggedIn', defaultValue: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping',
      theme: ThemeData(
        iconTheme: IconThemeData(color: darkGreenColor),
        colorScheme: ColorScheme.fromSeed(seedColor: darkGreenColor),
        useMaterial3: false,
      ),
      home: isLoggedIn ? HomeView() : LoginView(),
    );
  }
}
