import 'package:flutter/material.dart';
import 'package:news_dio_app/models/NewsResponce.dart';
import 'package:news_dio_app/services/new_services_api.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discover',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Find interesting article and news',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: FutureBuilder(
                      future: NewsApiServices().fetchNewsArticles(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Article>? newsArticle = snapshot.data;
                        return ListView.builder(
                            itemCount: newsArticle?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(7),
                                child: ListTile(
                                    onTap: () async {
                                      await canLaunchUrl(Uri.parse(
                                              newsArticle![index]
                                                  .url
                                                  .toString()))
                                          ? await launchUrl(Uri.parse(
                                              newsArticle![index]
                                                  .url
                                                  .toString()))
                                          : throw 'Couldnot launch '
                                              '${newsArticle![index].url}';
                                    },
                                    title: Text(
                                      newsArticle![index].title.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      newsArticle![index]
                                          .description
                                          .toString(),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading:
                                        newsArticle![index].urlToImage != null
                                            ? Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      newsArticle![index]
                                                          .urlToImage
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : null),
                              );
                            });
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
