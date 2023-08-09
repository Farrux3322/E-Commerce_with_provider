import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/services/add_news_screen.dart';
import 'package:e_commerce/services/local_database.dart';
import 'package:e_commerce/services/news_model.dart';
import 'package:e_commerce/services/sing_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});


  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsModel> news = [];
  List<NewsModel> news1 = [];

  _updateNews() async {
    news = await LocalDatabase.getAllNews();
    setState(() {});
  }


  @override
  void initState() {
    print("Kirdiiiiiiiiiiiiiiiiiiiii");
    _updateNews();
    // TODO: implement initState
    super.initState();
  }

  bool check = false;

  checking()async{
    check ? await FirebaseMessaging.instance.subscribeToTopic("news") : await FirebaseMessaging.instance.unsubscribeFromTopic("news");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [

          Switch(value: check, onChanged: (value){
            setState(() {
              check=!check;
              checking();
            });
          }),

          IconButton(onPressed: ()async{
            await LocalDatabase.delete();
            setState(() {
              _updateNews();
            });
          }, icon: Icon(Icons.delete,color: Colors.red,))
        ],
        title: Text(
          "Yangiliklar Faqat Bizda",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          news = await LocalDatabase.getAllNews();
          setState(() {});
        },
        child: Column(
          children: [
            news.isNotEmpty
                ? Expanded(
                    child: ListView(
                    children: [
                      ...List.generate(news.length, (index) {
                        NewsModel newsModel = news[index];
                        return Container(
                          margin: EdgeInsets.all(18),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 10)
                              ]),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleDetailScreen(
                                          newsModel: newsModel)));
                            },
                            title: Text(newsModel.title),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: newsModel.image,
                                width: 80,
                                height: 80,
                                placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ))
                : Center(child: Lottie.asset("assets/images/empty.json"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewsScreen(onSomethingChanged: ()async{
            news = await LocalDatabase.getAllNews();
            setState(() {});
          },)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
