import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_dress/models/products.dart';
import 'package:ecommerce_dress/models/user.dart';
import 'package:ecommerce_dress/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

String get documentIdProduct => DateTime.now().toIso8601String();

abstract class DatabaseService {
  Future<User> getUserData(String uid);
  Future<void> storeUserProducts(Products products);
  Future<void> addToCart(Products products, String uid);
  Stream<List<Products>> getProductsDetail();
  Future<void> removeFromCart(String pid, String uid);
  getUid();
  Stream<List<Products>> getUserCartDetail(String uid);
}

class Database implements DatabaseService {
  Future<User> getUserData(String uid) async {
    String path = 'users/$uid';
    final refernce = Firestore.instance.document(path);
    final data = await refernce.get().then((value) => User.fromMap(value.data));
    print(data);
    return data;
  }

  Future<void> storeUserProducts(Products products) async {
    try {
      String path = "products/${products.pid}";
      final reference = Firestore.instance.document(path);
      await reference.setData(products.toMap());
    } on PlatformException catch (e) {
      print(e.code);
      throw PlatformException(
          code: e.code,
          message: 'Some Error occured',
          details: 'try again later');
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<Products>> getProductsDetail() {
    String path = "products/";
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.documents.map((snap) => Products.fromMap(snap.data)).toList());
  }

  Future<void> addToCart(Products products, String uid) async {
    String path = "users/$uid/cart/${products.pid}";
    final reference = Firestore.instance.document(path);
    await reference.setData(products.toMap());
  }

  Future<void> removeFromCart(String pid, String uid) async {
    String path = "users/$uid/cart/$pid";
    final reference = Firestore.instance.document(path);
    await reference.delete();
  }

  Future<String> getUser() async {
    AuthService auth = Auth();
    FirebaseUser user = await auth.checkUserAuthenticated();
    return user == null ? null : user.uid;
  }

  getUid() async {
    String uid = await getUser();
    return uid;
  }

  Stream<List<Products>> getUserCartDetail(String uid) {
    String path = "users/$uid/cart/";
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.documents.map((snap) => Products.fromMap(snap.data)).toList());
  }
}
