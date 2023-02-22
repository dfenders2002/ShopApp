import 'package:flutter/material.dart';

class fitnessRow extends StatelessWidget {
  const fitnessRow({Key key}) : super(key: key);

  Widget gymRow() {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10.0,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.all(10),
            child: Icon(Icons.whatshot),
          ),
          Container(
            height: 50,
            child: Column(
              children: [Text('Test'), Text('Test')],
            ),
          ),
          Container(
            child: Icon(Icons.arrow_drop_down),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) => gymRow()),
        itemCount: 20,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
