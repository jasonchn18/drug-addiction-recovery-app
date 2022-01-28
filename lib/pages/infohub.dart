// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// import 'dart:async';

class InfoHub extends StatefulWidget {
  const InfoHub({ Key? key }) : super(key: key);

  @override
  _InfoHubState createState() => _InfoHubState();
}

class _InfoHubState extends State<InfoHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
          children: <Widget>[
            TextButton.icon(
              onPressed: () {}, 
              icon: Icon(
                Icons.menu_book_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Info Hub screen',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/article');
              },
              child: Text(
                'Sample Article',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Article extends StatelessWidget {
  const Article({ Key? key }) : super(key: key);

  // final String title;
  // final String selectedUrl;

  // final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Title'),
        // centerTitle: true,
        backgroundColor: Color.fromRGBO(4, 98, 126,1.0),
        elevation: 0.0,
      ),
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Text('article content'),
    );
  }
}

// class Article extends StatefulWidget {
//   const Article({ Key? key }) : super(key: key);

//   @override
//   _ArticleState createState() => _ArticleState();
// }

// class _ArticleState extends State<Article> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Article Title'),
//         // centerTitle: true,
//         backgroundColor: Color.fromRGBO(4, 98, 126,1.0),
//         elevation: 0.0,
//       ),
//       backgroundColor: Color.fromRGBO(240,240,235,1.0),
//       body: WebView(),
//     );
//   }
// }