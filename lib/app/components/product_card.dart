import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce_dress/models/products.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Products products;
  const ProductCard({
    this.products,
    Key key,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
    // Uint8List data = await firebaseStorageRef.getData(10 * 1024 * 1024);
    setState(() {
      downloadUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            // margin: EdgeInsets.only(right: 20, left: 20),
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Container(
              height: 140,
              width: 150,
              child: Center(
                child: downloadUrl == null
                    ? CircularProgressIndicator()
                    : Image.network(downloadUrl),
              ),
            ),
          ),
          Positioned(
            left: 50,
            top: 25,
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width - 170,
              child: Text(
                '${widget.products.title}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Text(
                  'Rs. ${widget.products.price}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
