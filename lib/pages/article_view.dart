import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
String blogUrl;
ArticleView({required this.blogUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
   @override
  void initState() {
    super.initState();
    print('ArticleView received URL: ${widget.blogUrl}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ANTUVN",
        
              style: TextStyle(color: Color.fromARGB(255, 11, 129, 0), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
      child: WebView(
        initialUrl:widget.blogUrl ,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    ));
  }
}