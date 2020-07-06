import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce_dress/app/cart_page.dart';
import 'package:ecommerce_dress/app/sign_in/login.dart';
import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/models/products.dart';
import 'package:ecommerce_dress/models/user.dart';
import 'package:ecommerce_dress/services/auth_service.dart';
import 'package:ecommerce_dress/services/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDisplayPage extends StatefulWidget {
  final String uid;
  final DatabaseService database;
  final Products products;
  final AuthService auth;
  ProductDisplayPage({this.products, this.database, this.uid, this.auth});

  @override
  _ProductDisplayPageState createState() => _ProductDisplayPageState();
}

class _ProductDisplayPageState extends State<ProductDisplayPage> {
  bool pressed = false;
  String downloadUrl;
  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('product_images/${widget.products.image}');
    final url = await firebaseStorageRef.getDownloadURL();
    setState(() {
      downloadUrl = url;
    });
  }

  void _addToCart() async {
    setState(() {
      pressed = true;
    });
    String uid = await widget.database.getUid();
    if (uid == null) {
      setState(() {
        pressed = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login.create(context),
          ));
    } else {
      await widget.database.addToCart(widget.products, uid);
      Fluttertoast.showToast(
          msg: "Produt Added To cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        pressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: height - height / 4,
                width: width,
                color: Colors.white.withOpacity(0.7),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Dress',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Opacity(
                            opacity: 0,
                            child: Text(
                              'Dress',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: (height - height / 4) - 45,
                        child: Center(
                          child: downloadUrl == null
                              ? CircularProgressIndicator()
                              : Image.network(downloadUrl,
                                  height:
                                      MediaQuery.of(context).size.height / 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Price: Rs. ${widget.products.price}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              pressed == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
              SizedBox(height: 15),
              Text(
                '${widget.products.description}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: pressed ? null : _addToCart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<User>(
          stream: widget.auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              if (user != null) {
                return FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartPage(database: widget.database, uid: user.uid),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    color: backgroundColor,
                  ),
                  backgroundColor: Colors.white,
                );
              }
              return Container();
            }
            return Container();
          }),
    );
  }
}
