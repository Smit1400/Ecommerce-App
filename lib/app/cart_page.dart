import 'package:ecommerce_dress/app/components/product_card.dart';
import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/models/products.dart';
import 'package:ecommerce_dress/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  final DatabaseService database;
  final String uid;
  CartPage({this.database, this.uid});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalAmount = 0;
  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Swipe Left to remove item from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _removeFromCart(String pid) async {
    await widget.database.removeFromCart(pid, widget.uid);
    Fluttertoast.showToast(
        msg: "Produt Removed from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _proceedToPayment() async {
    print("total amount = $totalAmount");
    var options = {
      'key': 'rzp_test_TG85QHB6Lb6vs6',
      'amount': totalAmount * 100,
      'name': 'Clothify',
      'description': 'Buying',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Cart'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<Products>>(
        stream: widget.database.getUserCartDetail(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<Products> product = snapshot.data;

            if (product.isNotEmpty) {
              var amount = 0;
              for (var i in product) {
                amount += i.price;
              }
              totalAmount = amount;

              return ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(documentIdProduct),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) =>
                        _removeFromCart(product[index].pid),
                    background: Container(
                      color: Colors.red,
                    ),
                    // onDismissed: _removeFromCart,
                    child: ProductCard(
                      products: product[index],
                    ),
                  );
                },
              );
            } else {
              totalAmount = 0;
              return Center(
                child: Text(
                  'No items in Cart',
                  style: TextStyle(color: Colors.grey, fontSize: 25),
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 50,
          child: RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Proceed to check out',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
            onPressed: _proceedToPayment,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
