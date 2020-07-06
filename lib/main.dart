import 'package:ecommerce_dress/app/add_dress_page.dart';
import 'package:ecommerce_dress/app/products_list_page.dart';
import 'package:ecommerce_dress/app/sign_in/register.dart';
import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/services/auth_service.dart';
import 'package:ecommerce_dress/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(MyApp());
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animationController.forward();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
          (route) => false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -5),
                end: Offset.zero,
              ).animate(_animationController),
              child: FadeTransition(
                opacity: _animationController,
                child: Text(
                  'Clothify',
                  style: TextStyle(
                    fontSize: 65,
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(_animationController),
              child: FadeTransition(
                opacity: _animationController,
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('images/ecom.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Provider<DatabaseService>(
          create: (_) => Database(),
          child: ProductsListPage(),
        ),
      ),
    );
  }
}
