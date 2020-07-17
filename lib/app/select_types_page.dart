import 'package:ecommerce_dress/constants/constants.dart';
import 'package:flutter/material.dart';

class SelectTypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List types = [
      {'title': 'All', 'img': 'images/dress.png'},
      {'title': 'Men', 'img': 'images/men.png'},
      {'title': 'Women', 'img': 'images/women.png'},
      {'title': 'Kids', 'img': 'images/kids.png'}
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Select Types'),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: types.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, '${types[index]["title"]}');
              },
              child: Container(
                height: 100,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white.withOpacity(0.7),
                width: MediaQuery.of(context).size.width - 20,
                child: Center(
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Text('${types[index]["title"]}'),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    ),
                    trailing: Image.asset('${types[index]["img"]}'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
