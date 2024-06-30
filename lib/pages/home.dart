import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapi/models/category_model.dart';
import 'package:newsapi/models/slider_model.dart';
import 'package:newsapi/models/article_models.dart';
import 'package:newsapi/pages/article_view.dart';
import 'package:newsapi/pages/category_news.dart';
import 'package:newsapi/screens/favroite_proivder.dart';
import 'package:newsapi/services/data.dart';
import 'package:newsapi/services/slider_data.dart';
import 'package:newsapi/services/news.dart';
import 'package:newsapi/sqlitedatabase/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController? scrollController;
  bool _isBottomBarVisible = true;
  bool _isAppBarVisible = true;
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getSlider();
    getNews();
    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    setState(() {
      articles = newsClass.news;
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    setState(() {
      sliders = slider.sliders;
    });
  }

  void _scrollListener() {
    if (scrollController!.position.userScrollDirection == ScrollDirection.reverse) {
      setState(() {
        _isBottomBarVisible = false;
        _isAppBarVisible = false;
      });
    } else if (scrollController!.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {
        _isBottomBarVisible = true;
        _isAppBarVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAppBarVisible
          ? AppBar(
              title: Text(
                "News",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            )
          : PreferredSize(
              preferredSize: Size(0.0, 0.0),
              child: Container(),
            ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  if (categories.isNotEmpty)
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
                  if (sliders.isNotEmpty)
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
                  if (sliders.isNotEmpty) Center(child: buildIndicator()),
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
                  if (articles.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        final favoriteArticle = article.toFavoriteArticle();
                        final isFavorite = context.watch<FavoritesProvider>().isFavorite(favoriteArticle);

                        return BlogTile(
                          url: article.url!,
                          desc: article.description!,
                          title: article.title!,
                          imageUrl: article.urlToImage!,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () {
                            final provider = context.read<FavoritesProvider>();
                            if (isFavorite) {
                              provider.removeFavorite(favoriteArticle);
                            } else {
                              provider.addFavorite(favoriteArticle);
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
      bottomNavigationBar: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: _isBottomBarVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: BottomNavigationBar(
          backgroundColor: Colors.green,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.red,
              icon: Icon(Icons.home, color: Colors.white),
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
              Navigator.pushReplacementNamed(context, '/favorites');
            }
          },
        ),
        secondChild: SizedBox.shrink(),
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
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: sliders.length,
        effect: SlideEffect(dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
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
          context,
          MaterialPageRoute(builder: (context) => CategoryNews(name: categoryName)),
        );
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
                    fontWeight: FontWeight.bold,
                  ),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.0),
                Text(
                  desc,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
