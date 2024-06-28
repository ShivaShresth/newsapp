import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapi/models/article_model.dart';
import 'package:newsapi/models/slider_model.dart';
import 'package:newsapi/pages/article_view.dart';
import 'package:newsapi/services/news.dart';
import 'package:newsapi/services/slider_data.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({super.key, required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlider();
    getNews();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.news + "News"), centerTitle: true, elevation: 0.0),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount:
                  widget.news == "Breaking" ? sliders.length : articles.length,
              itemBuilder: (context, index) {
                return AllNewsSection(
                  Image: widget.news == "Breaking"
                      ? sliders[index].urlToImage!
                      : articles[index].urlToImage!,
                  desc: widget.news == "Breaking"
                      ? sliders[index].description!
                      : articles[index].description!,
                  title: widget.news == "Breaking"
                      ? sliders[index].title!
                      : articles[index].title!,
                  url: widget.news == "Breaking"
                      ? sliders[index].url!
                      : articles[index].url!,
                );
              })),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  String Image, desc, title, url;
  AllNewsSection(
      {super.key,
      required this.Image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: Image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              title,
              maxLines: 2,
            ),
            Text(
              desc,
              maxLines: 3,
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
