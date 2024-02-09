import 'dart:convert';

import 'package:newsapp/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/pages/saved_articles_service.dart';

class News{
  List<ArticleModel> news=[];
  
  
  Future<void> getNews()async{
String url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=54145bc9681c42de9a6cc831aa90502b";
 var response= await http.get(Uri.parse(url));

var jsonData= jsonDecode(response.body);

if(jsonData['status']=='ok'){
  jsonData["articles"].forEach((element){
    if(element["urlToImage"]!=null && element['description']!=null){
      ArticleModel articleModel= ArticleModel(
        title: element["title"],
        description: element["description"],
        url: element["url"],
        urlToImage: element["urlToImage"],
        content: element["content"],
        author: element["author"],
        isOffline: element["downloaded"] ?? false,
      );
      news.add(articleModel);
    }
  });
}
 
  }
}