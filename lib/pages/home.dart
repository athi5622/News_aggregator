import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/category_model.dart';
import 'package:newsapp/models/slider_model.dart';
import 'package:newsapp/pages/SavedArticlesScreen.dart';
import 'package:newsapp/pages/all_news.dart';
import 'package:newsapp/pages/article_view.dart';
import 'package:newsapp/pages/category_news.dart';

import 'package:newsapp/services/data.dart';
import 'package:newsapp/services/news.dart';
import 'package:newsapp/services/slider_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'saved_articles_service.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true, loading2=true;

  int activeIndex = 0;
  @override
  void initState() {
    categories = getCategories();
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

    getSlider() async {
    Sliders slider= Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
  setState(() {
    loading2=false;
  });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "ANTUVN",
              style: TextStyle(
                color: Color.fromARGB(255, 9, 177, 37),
                fontSize: 25.0,
                 fontWeight: FontWeight.bold),
            )
          ],
        ),
         actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
             
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
            },
          ),
        ],
      ),
        
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      height: 70,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              image: categories[index].image,
                              categoryName: categories[index].categoryName,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Breaking News!",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Breaking")));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color.fromARGB(255, 9, 177, 37),
                                  color: const Color.fromARGB(255, 9, 177, 37),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  if (loading2) Center(child: CircularProgressIndicator()) else CarouselSlider.builder(
                        itemCount: 5,
                        itemBuilder: (context, index, realIndex) {
                          String? res = sliders[index].urlToImage;
                          String? res1 = sliders[index].title;
                          return buildImage(res!, index, res1!);
                        },
                        options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            })),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(child: buildIndicator()),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending News!",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          GestureDetector(
                            onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Trending")));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color.fromARGB(255, 9, 177, 37),
                                  color: const Color.fromARGB(255, 29, 73, 108),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return BlogTile(
                              url:  articles[index].url!,
                                desc: articles[index].description!,
                                imageUrl: articles[index].urlToImage!,
                                title: articles[index].title!, 
                                isOffline: true,
                              );
                          }),
                    ),
                  ],
                ),
              ),
            ),
             bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: _selectedIndex == 0 ? Colors.green : Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
            backgroundColor: _selectedIndex == 1 ? Colors.green : Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
            backgroundColor: _selectedIndex == 2 ? Colors.green : Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: _selectedIndex == 3 ? Colors.green : Colors.transparent,
            
          ),
        ],
         onTap: (int index){
          setState(() {
            _selectedIndex = index;
                if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedArticlesScreen()),
      );
                }
          });
        }
      ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
      
            height: 220,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width, imageUrl: image,
          ),
        ),
        Container(
          height: 200,
          padding: EdgeInsets.only(left: 10.0),
          margin: EdgeInsets.only(top: 170.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]));

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: SlideEffect(
            dotWidth: 25, dotHeight: 3, activeDotColor: Colors.green),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                 image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
               
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                  child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatefulWidget {
   final String imageUrl;
  final String title;
  final String desc;
  final String url;
  final bool isOffline;


  BlogTile({
    required this.desc,
   required this.imageUrl,
    required this.title, 
    required this.url,
     required this.isOffline,
       Key? key,
  }) : super(key: key);

  @override
State<BlogTile> createState() => _BlogTileState();
}
class _BlogTileState extends State<BlogTile> {
 late bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  void _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('savedArticles') ?? [];
    final articleData = _serializeArticle(widget);
    _isSaved = savedArticles.contains(articleData); //
    setState(() {});
  }
  String _serializeArticle(BlogTile widget) {
    Map<String, dynamic> articleMap = {
      'title': widget.title,
      'desc': widget.desc,
      'imageUrl': widget.imageUrl,
      'url': widget.url,
    };
    return jsonEncode(articleMap);
  }


  void _toggleSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles= prefs.getStringList('savedArticles') ?? [];
     final articleData = _serializeArticle(widget);

    if (_isSaved) {
      savedArticles.remove(articleData);
    } else {
      savedArticles.add(articleData);
    }

    await prefs.setStringList('savedArticles',savedArticles);
    setState(() {
      _isSaved = !_isSaved;
    });
  }


  @override
 Widget build(BuildContext context) {
  const double boxWidth = 160.0;
  const double boxHeight = boxWidth * 0.9;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: double.infinity,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: boxWidth,
          maxHeight: boxHeight,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: -3.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: -3.0),
          leading: SizedBox(
            width: 100,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                width: boxWidth,
                child: Text(
                  widget.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleSaved,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArticleView(blogUrl: widget.url)),
            );
          },
        ),
      ),
    ),
  );
}

}
