import 'package:flutter/material.dart';

class ListViewTypes extends StatefulWidget {
  ListViewTypes({
    Key key,
    @required this.type,
  }) : super(key: key);

  final List<String> type;

  @override
  _ListViewTypesState createState() => _ListViewTypesState();
}

class _ListViewTypesState extends State<ListViewTypes> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.type.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              height: 15,
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Colors.white.withOpacity(0.7)
                    : null,
              ),
              child: Text(
                '${widget.type[index]}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
