import 'package:flutter/material.dart';
void main() => runApp(new MaterialApp(
  home: new Demo1(),
));
class Demo1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<Demo1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Icon Button Click');
          },
        ),*/
        title: Text('Appbar'),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],*/
        flexibleSpace: SafeArea(
          child: Icon(
            Icons.camera,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 75.0,
            width: double.infinity,
            child: Text(
              'Tutor Joes',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ),
          preferredSize: Size.fromHeight(75.0),
        ),
      ),
      body: Center(
        child: Text(
          'Tutor Joes',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.red,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.add),
        onPressed: () {
          print('Tutor Joes Click');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Tutor Joes'),
              accountEmail: Text('tutorjoes@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('Xyz'),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('Xyz'),
                )
              ],
            ),
            ListTile(
              title: Text('All Inbox'),
              leading: Icon(Icons.mail),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Primary'),
              leading: Icon(Icons.inbox),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Social'),
              leading: Icon(Icons.people),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Promotions'),
              leading: Icon(Icons.local_offer),
            ),
            Divider(
              height: 0.1,
            )
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          elevation: 10.0,
          onPressed: () {
            print('Click');
          },
          color: Colors.red,
          child: Icon(Icons.add),
        ),
        RaisedButton(
          elevation: 10.0,
          onPressed: () {
            print('Click');
          },
          color: Colors.green,
          child: Icon(Icons.clear),
        ),
      ],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text('Add'),
            icon: Icon(Icons.add),
          )
        ],
        onTap: (int index) {
          print(index.toString());
        },
      ),
      endDrawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Tutor Joes'),
              accountEmail: Text('tutorjoes@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('Xyz'),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('Xyz'),
                )
              ],
            ),
            ListTile(
              title: Text('All Inbox'),
              leading: Icon(Icons.mail),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Primary'),
              leading: Icon(Icons.inbox),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Social'),
              leading: Icon(Icons.people),
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Promotions'),
              leading: Icon(Icons.local_offer),
            ),
            Divider(
              height: 0.1,
            )
          ],
        ),
      ),
      backgroundColor: Colors.teal,
    );
  }
}