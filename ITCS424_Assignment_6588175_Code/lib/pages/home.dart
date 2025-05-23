import 'package:flutter/material.dart';
import 'myNotebook.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, Amily',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.person)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                fixedSize: Size(250, 80)
              ),
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MynotebookPage()
                    ),
                  );
                }, 
                child: Text(
                  'My Notebook',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white
                  ),
                ),
                
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                fixedSize: Size(250, 80)
              ),
              onPressed: () {}, 
              child: Text(
                'Community',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}
