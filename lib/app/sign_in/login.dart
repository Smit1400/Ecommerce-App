import 'package:ecommerce_dress/app/sign_in/register.dart';
import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static Widget create(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => Auth(),
      child: Login(),
    );
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dipose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _submit() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signInUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("${e.code}"),
            content: new Text("${e.details}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: _buildContent(),
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(
              'images/ecom.jpg',
            ),
            radius: MediaQuery.of(context).size.width / 2 - 20,
          ),
          SizedBox(height: 25),
          _buildEmailTextField(),
          SizedBox(height: 15),
          _buildPasswordTextField(),
          SizedBox(height: 15),
          _signUpButton(),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              );
            },
            child: Text(
              'Don\'t have an Account? Create Account',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _signUpButton() {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: _submit,
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Text('Login'),
      ),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
