import 'package:ecommerce_dress/app/add_dress_page.dart';
import 'package:ecommerce_dress/app/cart_page.dart';
import 'package:ecommerce_dress/app/components/product_card.dart';
import 'package:ecommerce_dress/app/components/search_bar.dart';
import 'package:ecommerce_dress/app/product_display_page.dart';
import 'package:ecommerce_dress/app/select_types_page.dart';
import 'package:ecommerce_dress/app/sign_in/login.dart';
import 'package:ecommerce_dress/app/sign_in/register.dart';
import 'package:ecommerce_dress/constants/constants.dart';
import 'package:ecommerce_dress/models/products.dart';
import 'package:ecommerce_dress/models/user.dart';
import 'package:ecommerce_dress/services/auth_service.dart';
import 'package:ecommerce_dress/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsListPage extends StatefulWidget {
  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage>
    with SingleTickerProviderStateMixin {
  List<String> type = ['All', 'Western', 'Traditional', 'Wedding', 'Kurti'];

  String _selectType = "All";

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final database = Provider.of<DatabaseService>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Gada\'s Creation'),
        centerTitle: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'images/ecom.jpg',
              ),
              radius: 25,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchBar(),
            SizedBox(height: 15),
            InkWell(
              onTap: () async {
                final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectTypesPage(),
                    ));
                setState(() {
                  _selectType = value;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Select Types',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 40,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  StreamBuilder<List<Products>>(
                      stream: database.getProductsDetail(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          List<Products> product =
                              snapshot.hasData ? snapshot.data : [];
                          print(product);
                          return ListView.builder(
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              return _selectType == 'All'
                                  ? SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(-1, 0),
                                        end: Offset.zero,
                                      ).animate(_animationController),
                                      child: InkWell(
                                        onTap: () {
                                          // _animationController.dispose();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDisplayPage(
                                                  database: database,
                                                  products: product[index],
                                                  auth: auth,
                                                ),
                                              ));
                                        },
                                        child: ProductCard(
                                            products: product[index]),
                                      ),
                                    )
                                  : _selectType == product[index].type
                                      ? SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset(-1, 0),
                                            end: Offset.zero,
                                          ).animate(_animationController),
                                          child: InkWell(
                                            onTap: () {
                                              // _animationController.dispose();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDisplayPage(
                                                      database: database,
                                                      products: product[index],
                                                      auth: auth,
                                                    ),
                                                  ));
                                            },
                                            child: ProductCard(
                                                products: product[index]),
                                          ),
                                        )
                                      : Container();
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<User>(
          stream: auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              if (user != null) {
                return FloatingActionButton(
                  onPressed: () {
                    _animationController.dispose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartPage(database: database, uid: user.uid),
                      ),
                    );
                  },
                  child: Icon(Icons.shopping_cart),
                  backgroundColor: backgroundColor,
                );
              }
              return Container();
            }
            return Container();
          }),
      drawer: StreamBuilder<User>(
          stream: auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              return Drawer(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            // backgroundColor: Colors.red,
                            backgroundImage: AssetImage('images/ecom.jpg'),
                            radius: 40,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Clothify',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.black,
                      ),
                      user != null
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Profile',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.portrait)
                                      ],
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Sell a dress',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.create)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddDresspage.create(
                                                  context, user.uid),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Logout',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.exit_to_app)
                                      ],
                                    ),
                                    onPressed: () async {
                                      await auth.logout();
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Sign up',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.person_add)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Register.create(context),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Login',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.person)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Login.create(context),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 10),
                      Divider(),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Settings',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.settings),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
