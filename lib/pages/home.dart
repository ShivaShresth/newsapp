import 'package:flutter/material.dart';
import 'package:newsapi/models/category_model.dart';
import 'package:newsapi/models/slider_model.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:newsapi/services/slider_data.dart';
import 'package:provider/provider.dart';
import 'package:newsapi/models/article_model.dart';
import 'package:newsapi/pages/article_view.dart';
import 'package:newsapi/pages/category_news.dart';
import 'package:newsapi/services/data.dart';
import 'package:newsapi/services/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    categories = getCategories();
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          image: categories[index].image!,
                          categoryName: categories[index].categoryName!,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Breaking News", style: TextStyle(color: Colors.black)),
                        Text("View All", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CarouselSlider.builder(
                    itemCount: sliders.length,
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
                      },
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(child: buildIndicator()),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Trending News", style: TextStyle(color: Colors.black)),
                        Text("View All", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        final isFavorite = context.watch<FavoritesProvider>().isFavorite(article);
                        return BlogTile(
                          url: article.url!,
                          desc: article.description!,
                          title: article.title!,
                          imageUrl: article.urlToImage!,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () {
                            final provider = context.read<FavoritesProvider>();
                            if (isFavorite) {
                              provider.removeFavorite(article);
                            } else {
                              provider.addFavorite(article);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, '/favorites');
          }
        },
      ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              height: 250,
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: 170),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(10))),
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: sliders.length,
        effect: SlideEffect(
            dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
      );
}

class CategoryTile extends StatelessWidget {
  final String image, categoryName;

  CategoryTile({super.key, required this.image, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CategoryNews(name: categoryName)));
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
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  BlogTile({
    super.key,
    required this.url,
    required this.desc,
    required this.title,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
        child: Material(
          elevation: 3.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        desc,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
