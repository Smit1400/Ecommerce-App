import 'dart:typed_data';

import 'dart:ui';

class Products {
  final String pid;
  final String uid;
  final String title;
  final String description;
  final String type;
  final String image;
  final int totalItems;
  final String email;
  final int price;

  Products(
      {this.pid,
      this.uid,
      this.price,
      this.email,
      this.title,
      this.description,
      this.type,
      this.image,
      this.totalItems});

  factory Products.fromMap(Map<dynamic, dynamic> data) {
    return Products(
      email: data["email"],
      pid: data["pid"],
      uid: data["uid"],
      price: data["price"],
      title: data["title"],
      description: data["description"],
      type: data["type"],
      image: data["image"],
      totalItems: data["totalItems"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'uid': uid,
      'price': price,
      'email': email,
      'title': title,
      'description': description,
      'type': type,
      'image': image,
      'totalItems': totalItems,
    };
  }
}
