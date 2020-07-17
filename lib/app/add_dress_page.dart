import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/models/products.dart';
import 'package:ecommerce_dress/models/user.dart';
import 'package:ecommerce_dress/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:path/path.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDresspage extends StatefulWidget {
  final String uid;
  AddDresspage({this.uid});
  static Widget create(BuildContext context, String uid) {
    return Provider<DatabaseService>(
      create: (_) => Database(),
      child: AddDresspage(uid: uid),
    );
  }

  @override
  _AddDresspageState createState() => _AddDresspageState();
}

class _AddDresspageState extends State<AddDresspage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _totalItemController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File _selectedImage;
  int length;
  String _chosenValue = "Categorize Your Dress";

  List<Attachment> attachment = <Attachment>[];

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _totalItemController.dispose();
  }

  _uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = tempImage;

      attachment.add(FileAttachment(tempImage));
    });
  }

  void _submit(BuildContext context) async {
    try {
      final database = Provider.of<DatabaseService>(context, listen: false);
      String username = 'shahsmit01042000@gmail.com';
      String password = 'smitchhadva';
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${basename(_selectedImage.path)}');
      final StorageUploadTask task = firebaseStorageRef.putFile(_selectedImage);
      User user = await database.getUserData(widget.uid);
      Products products = Products(
          pid: 'products_$documentIdProduct',
          uid: user.uid,
          title: _titleController.text,
          description: _descriptionController.text,
          totalItems: int.parse(_totalItemController.text),
          price: int.parse(_priceController.text),
          type: _chosenValue,
          image: basename(_selectedImage.path),
          email: user.email);
      await database.storeUserProducts(products);
      Navigator.pop(context);
      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username, 'shahsmit01042000@gmail.com')
        ..recipients.add('${user.email}')
        ..subject = '${_titleController.text}'
        ..text = '${_descriptionController.text}'
        ..attachments = attachment
        ..html =
            "<h1>Congratulations</h1><p>Your products has been added, you will receive an email if anyone buys your products.\n Your duty will be to deliver the products in 5 days, otherwise we may have to take some actions.</p>";

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                'images/ecom.jpg',
              ),
              radius: 20,
            ),
            Text('Upload a Product'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
    );
  }

  Padding _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: <Widget>[
          SizedBox(height: 25),
          _buildTitleTextField(),
          SizedBox(height: 15),
          _buildDescriptionTextField(),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: Colors.white, style: BorderStyle.solid, width: 2),
            ),
            child: DropdownButton<String>(
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.black,
              ),
              value: _chosenValue,
              isExpanded: true,
              underline: Container(),
              items: <String>[
                'Categorize Your Dress',
                'Western',
                'Traditional',
                'Wedding',
                'Kurti'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenValue = value;
                });
              },
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _totalNumberOfItemsTextField(),
              ),
              SizedBox(width: 7),
              Expanded(
                child: _priceTextField(),
              ),
            ],
          ),
          SizedBox(height: 15),
          _addImageButton(),
          SizedBox(height: 15),
          _signUpButton(context),
        ],
      ),
    );
  }

  SizedBox _signUpButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: () => _submit(context),
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          'Upload Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  TextField _priceTextField() {
    return TextField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Price',
        filled: true,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(30),
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

  TextField _totalNumberOfItemsTextField() {
    return TextField(
      controller: _totalItemController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Total Items',
        filled: true,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(30),
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

  TextField _buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      keyboardType: TextInputType.emailAddress,
      maxLines: 6,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Description',
        filled: true,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(30),
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

  TextField _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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

  Widget _addImageButton() {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: _uploadImage,
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: <Widget>[
            _selectedImage != null
                ? Text('.....image attached')
                : Text(
                    'Pick Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
